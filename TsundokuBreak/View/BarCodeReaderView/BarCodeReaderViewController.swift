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
import AlamofireImage
import SwiftGifOrigin
import MBProgressHUD
import MaterialComponents
import CDAlertView

final class BarCodeReaderViewController: UIViewController, Injectable, AVCaptureMetadataOutputObjectsDelegate {

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
    @IBOutlet weak var bookImage: UIImageView! {
        didSet {
            bookImage.image = UIImage.gif(name: "lupe")
        }
    }

    @IBOutlet weak var instructLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func testButtonPush(_ sender: Any) {
        self.isbnRelay.accept("9784873116594")
    }

    let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
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

    private func setup() {
        let input = BarCodeReaderViewModelInput(
            isbnRelay: isbnRelay,
            addButton: addButton.rx.tap
        )
        viewModel.setup(input: input)
        setLabelConfig()
        setEmit()
    }

}

extension BarCodeReaderViewController {

    func setLabelConfig() {
        titleLabel.adjustsFontSizeToFitWidth = true
        authorLabel.adjustsFontSizeToFitWidth = true
    }

    func setEmit() {
        viewModel.outputs?.zeroItemSignal
            .emit(onNext: { [weak self] bool in
                guard let self = self else { return }
                if bool {
                    self.zeroItemTrueProcess()
                } else {
                    self.zeroItemFalseProcess()
                }
                MBProgressHUD.hide(for: self.view, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.urlSignal
            .emit(onNext: { [weak self] url in
                guard let self = self else { return }
                let filter = AspectScaledToFillSizeFilter(size: self.bookImage.frame.size)
                let placeFolder = UIImage.gif(name: "loading")
                self.bookImage.af.setImage(
                    withURL: url,
                    placeholderImage: placeFolder,
                    filter: filter,
                    imageTransition: .crossDissolve(0.5)
                )
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.titleSignal
            .emit(onNext: { [weak self] title in
                guard let self = self else { return }
                self.titleLabel.text = title
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.authorSignal
            .emit(onNext: { [weak self] author in
                guard let self = self else { return }
                self.authorLabel.text = author
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.publicationSignal
            .emit(onNext: { [weak self] publication in
                guard let self = self else { return }
                self.publicationLabel.text = publication
            })
            .disposed(by: disposeBag)

        viewModel.outputs?.pageCountSignal
            .emit(onNext: { [weak self] pageCount in
                guard let self = self else { return }
                self.pageCountLabel.text = pageCount
            })
            .disposed(by: disposeBag)
    }

    func zeroItemTrueProcess() {
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        let alert = CDAlertView(title: "バーコードエラー",
                                message: "下段のバーコードを読み取っているか、\nデータベースに該当書籍がありません。\n\nもう一度、\n上段のバーコードを読み取ってください",
                                type: .warning
        )
        let doneAction = CDAlertViewAction(
            title: "OK!",
            handler: { _ in self.restartCapture()}
        )
        alert.add(action: doneAction)
        alert.show()

    }

    func restartCapture() -> Bool {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.captureSession.startRunning()
        return true
    }

    func zeroItemFalseProcess() {
        instructLabel.text = "書籍のデータを取得しました"
        addButton.isEnabled = true
    }
}

extension BarCodeReaderViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkPermission()

        NotificationCenter.default.addObserver(self, selector: #selector(checkPermission), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc private func checkPermission() {
        switch cameraAuthStatus {
        case .notDetermined:
            requestCameraPermission()
        case .restricted, .denied:
            alertCameraAccessNeeded()
        case .authorized:
            break
        @unknown default:
            alertCameraAccessNeeded()
        }
    }

    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            print("camera permission ", accessGranted)
        })
    }

    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!

        let alert = UIAlertController(
            title: NSLocalizedString("need camera access", comment: ""),
            message: NSLocalizedString("camera usage perpose", comment: ""),
            preferredStyle: UIAlertController.Style.alert
        )

        alert.addAction(UIAlertAction(title: NSLocalizedString("don't allow", comment: ""), style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { (_) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))

        present(alert, animated: true, completion: nil)
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

        let barcodeImage: UIImage = R.image.barcode()!

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
        MBProgressHUD.showAdded(to: view, animated: true)
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
