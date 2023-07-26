//
//  Camera.swift
//  Xcerpt
//
//  Created by Brian Ho on 6/7/23.
//

import SwiftUI
import UIKit
import AVFoundation

struct Camera: UIViewControllerRepresentable {
    let capturedPhoto: Binding<UIImage?>
    
    // code from: https://stackoverflow.com/questions/64959542/pass-data-from-viewcontroller-to-representable-swiftui
    // this will be the delegate of the view controller, it's role is to allow
    // the data transfer from UIKit to SwiftUI
    class Coordinator: ViewControllerDelegate {
        let capturedPhotoBinding: Binding<UIImage?>
        
        init(capturedPhotoBinding: Binding<UIImage?>) {
            self.capturedPhotoBinding = capturedPhotoBinding
        }
        
        func photoTaken(_ viewController: ViewController, photo: UIImage) {
            // whenever the view controller notifies it's delegate about receiving a new photo
            // the line below will propagate the change up to SwiftUI
            capturedPhotoBinding.wrappedValue = photo
        }
    }
    
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        vc.delegate = context.coordinator
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    // this is very important, this coordinator will be used in `makeUIViewController`
    func makeCoordinator() -> Coordinator {
        Coordinator(capturedPhotoBinding: capturedPhoto)
    }
    
    typealias UIViewControllerType = ViewController
}

protocol ViewControllerDelegate: AnyObject {
    func photoTaken(_ viewController: ViewController, photo: UIImage)
}

// code from https://www.youtube.com/watch?v=ZYPNXLABf3c&t=1080s&ab_channel=iOSAcademy
class ViewController: UIViewController {
    weak var delegate: ViewControllerDelegate?
    // Capture Session
    var session: AVCaptureSession?
    // Photo Output
    let output = AVCapturePhotoOutput()
    // Video Preview
    let previewLayer = AVCaptureVideoPreviewLayer()
    // Shutter button
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.cornerRadius =  0.5 * button.bounds.size.width
        button.layer.borderWidth = 7
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermissions()
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspect
                //previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }
                self.session = session
            }
            catch {
                print(error)
            }
        }
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        let image = UIImage(data: data)
        delegate?.photoTaken(self, photo: image!)

        session?.stopRunning()
        /*
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)
         */
    }
}
