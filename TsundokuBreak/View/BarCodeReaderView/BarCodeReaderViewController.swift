//
//  BarCodeReaderViewController.swift
//  BarCodeReaderBreak
//
//  Created by Mizuki Kubota on 2020/03/28.
//  Copyright © 2020 MizukiKubota. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

class BarCodeReaderViewController: UIViewController, Injectable, AVCaptureMetadataOutputObjectsDelegate {

    typealias Dependency = BarCodeReaderViewModelType
    private let viewModel: BarCodeReaderViewModelType

    required init(with dependency: Dependency) {
        viewModel = dependency
        self.isbnRelay = PublishRelay<String>()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func bushCrossButton(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBOutlet weak var cameraView: UIView!

    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    private let disposeBag = DisposeBag()
    private let isbnRelay: PublishRelay<String>

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let readableArea = BarCodeReadableArea()
        barCodeReader(readableArea)
    }

    func setup() {
        let input = BarCodeReaderViewModelInput(
            isbnRelay: isbnRelay
        )
        viewModel.setup(input: input)

    }

}

extension BarCodeReaderViewController {
    func barCodeReader(_ barCodeReadableArea: BarCodeReadableArea) {
        // swiftlint:disable identifier_name
        let x: CGFloat = barCodeReadableArea.x
        let y: CGFloat = barCodeReadableArea.y
        // swiftlint:enable identifier_name
        let width: CGFloat = barCodeReadableArea.width
        let height: CGFloat = barCodeReadableArea.height

        cameraView.backgroundColor = UIColor.black
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
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)

        barCodeImageSet(x: x, y: y, width: width, height: height)

        captureSession.startRunning()
    }

    // swiftlint:disable identifier_name
    func barCodeImageSet(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {

        let barcodeImage: UIImage = UIImage(imageLiteralResourceName: "barcode")
        let imageView = UIImageView(image: barcodeImage)
        imageView.frame = CGRect(x: cameraView.frame.size.width * x, y: cameraView.frame.size.height * y, width: cameraView.frame.size.width * width, height: cameraView.frame.size.height * height)
        cameraView.addSubview(imageView)

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
    }

    func found(code: String) {
        isbnRelay.accept(code)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

extension BarCodeReaderViewController {
    static func makeVC () -> BarCodeReaderViewController {
        let model = BarCodeReaderModel(with: BarCodeReaderModel.Dependency.init())
        let viewModel =  BarCodeReaderViewModel(with: model)
        let viewControler =  BarCodeReaderViewController(with: viewModel)
        viewControler.modalPresentationStyle = .fullScreen
        return viewControler
    }
}
