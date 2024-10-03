//
//  ScreenRecorder.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import Foundation
import AVFoundation
import AppKit

class ScreenRecorder: NSObject, AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    
    let session = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    let photoOutput = AVCapturePhotoOutput()
    private var continuation: CheckedContinuation<Void, Error>?
    
    init(rect: CGRect) {
        super.init()
        guard let videoInput = AVCaptureScreenInput(displayID: CGMainDisplayID()) else { return }
        videoInput.cropRect = rect
        
        session.beginConfiguration()
        session.addInput(videoInput)
        session.addOutput(movieOutput)
        session.addOutput(photoOutput)
        session.commitConfiguration();
        session.startRunning()
    }
    
    private func getStorageFolder(_ filename: String) -> URL? {
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        if let folder = urls.first {
            return folder.appendingPathComponent(filename)
        }
        return nil
    }
    
    func record() {
        if let url = getStorageFolder("recording \(Date()).mov") {
            movieOutput.startRecording(to: url, recordingDelegate: self)
        }
    }
    
    func screenshot() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func stop() async throws {
        try await withCheckedThrowingContinuation { cnt in
            continuation = cnt
            movieOutput.stopRecording()
        }
        continuation = nil
        session.stopRunning()
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error {
            continuation?.resume(throwing: error)
        } else {
            continuation?.resume()
            NSWorkspace.shared.open(outputFileURL)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        let file = photo.fileDataRepresentation()
        let path  = getStorageFolder("recording \(Date()).png")!
        Task {
            try file?.write(to: path)
            NSWorkspace.shared.open(path)
        }
    }
}
