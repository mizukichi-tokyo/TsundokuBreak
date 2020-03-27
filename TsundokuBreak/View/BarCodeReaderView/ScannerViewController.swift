//
//  ScannerViewController.swift
//  TsundokuBreak
//
//  Created by Mizuki Kubota on 2020/03/24.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//
import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    struct BarcodeReadableArea {
        // swiftlint:disable identifier_name
        let x: CGFloat = 0.1
        let y: CGFloat = 0.4
        // swiftlint:enable identifier_name
        let width: CGFloat = 0.8
        let height: CGFloat = 0.2
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        barcodeReader(BarcodeReadableArea())

    }

}

extension ScannerViewController {
    func barcodeReader(_ barcodeReadableArea: BarcodeReadableArea) {
        // 読み取り可能エリアの設定を行う
        // 画面の横、縦に対して、左が10%、上が40%のところに、横幅80%、縦幅20%を読み取りエリアに設定
        // swiftlint:disable identifier_name
        let x: CGFloat = barcodeReadableArea.x
        let y: CGFloat = barcodeReadableArea.y
        // swiftlint:enable identifier_name
        let width: CGFloat = barcodeReadableArea.width
        let height: CGFloat = barcodeReadableArea.height

        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error occured while creating video device input")
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.rectOfInterest = CGRect(x: y, y: 1 - x - width, width: height, height: width)

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean13]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        barcodeImageSet(x: x, y: y, width: width, height: height)

        captureSession.startRunning()
    }

    // swiftlint:disable identifier_name
    func barcodeImageSet(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {

        let barcodeImage: UIImage = UIImage(imageLiteralResourceName: "barcode")
        let imageView = UIImageView(image: barcodeImage)
        imageView.frame = CGRect(x: view.frame.size.width * x, y: view.frame.size.height * y, width: view.frame.size.width * width, height: view.frame.size.height * height)
        view.addSubview(imageView)

    }
    // swiftlint:enable identifier_name

    func failed() {
        let alertController = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        print(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
