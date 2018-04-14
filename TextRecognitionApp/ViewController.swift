//
//  ViewController.swift
//  TextRecognitionApp
//
//  Created by seoju on 2018. 4. 14..
//  Copyright © 2018년 seoju. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession: AVCaptureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCameraPremission { (granted) in
            self.configureCamera()
        }
    }
}

// MARK: - Configuration
extension ViewController {

    func configureCamera() {
        
        guard let captureDevice: AVCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else { return }
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
            captureSession.sessionPreset = .high
            
        } catch {
            print("DeviceInput error")
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = self.view.layer.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
    }
    
    func configureTextDetection() {
        
    }
    
    func checkCameraPremission(_ handler: @escaping (_ granted: Bool) -> Void) {
        func hasCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        }
        
        func needsToRequestCameraPermission() -> Bool {
            return AVCaptureDevice.authorizationStatus(for: .video) == .notDetermined
        }
        
        hasCameraPermission() ? handler(true) : (needsToRequestCameraPermission() ?
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    hasCameraPermission() ? handler(true) : handler(false)
                }
            }) : handler(false))
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
}
