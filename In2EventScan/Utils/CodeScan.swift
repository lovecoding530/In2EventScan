//
//  CodeScanHelper.swift
//  In2EventScan
//
//  Created by Admin on 2/26/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol CodeScanDelegate {
    func foundCode(content: String)
    func notFoundCode()
}

class CodeScan : NSObject {
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var captureMetadataOutput: AVCaptureMetadataOutput!
    
    var qrCodeFrameView: UIView?
    
    let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]

    var delegate: CodeScanDelegate?
    
    var videoPreview: UIView!
    
    init (videoPreview: UIView) {
        super.init()
        
        self.videoPreview = videoPreview
        
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = videoPreview.layer.bounds
        videoPreview.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            videoPreview.addSubview(qrCodeFrameView)
            videoPreview.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    func start() {
        // Start video capture.
        captureSession.startRunning()
        qrCodeFrameView?.frame = CGRect.zero

        let x = CGFloat( 20.0 )
        let y = CGFloat( 100.0 )
        let widthOfLayer = videoPreview.frame.width
        let width = widthOfLayer - x * 2
        
        let rectOfInterest = CGRect(x: x, y: y, width: width, height: width)
        let realRect = videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
        self.captureMetadataOutput?.rectOfInterest = realRect!
    }
    
    func stop() {
        // Stop video capture.
        captureSession.stopRunning()
    }
}

extension CodeScan: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        guard let delegate = delegate else { return }
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            delegate.notFoundCode()
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                delegate.foundCode(content: metadataObj.stringValue!)
            }
        }
    }
}
