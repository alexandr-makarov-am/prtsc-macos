//
//  ScreenRecorder.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//
import AVFoundation
import Cocoa

final class ScreenRecorder: NSObject {
    private let input = AVCaptureScreenInput(displayID: CGMainDisplayID())
    private let output = AVCaptureMovieFileOutput()
    private let session = AVCaptureSession()
    
    override init() {}

    func record(rect: CGRect) {
        guard let input = input else {
            debugPrint("failed to initialize AVCaptureScreenInput")
            return
        }
        input.scaleFactor = 1.0
        input.cropRect = rect
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(output) {
            session.addOutput(output)
        }
        let tempVideoUrl = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("mov")
        session.startRunning()
        output.startRecording(to: tempVideoUrl, recordingDelegate: self)
    }
    
    func stop() {
        output.stopRecording()
        session.stopRunning()
        session.removeOutput(output)
        if let input = input {
            session.removeInput(input)
        }
    }
}

extension ScreenRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("started")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print(outputFileURL, "finished")
        NSWorkspace.shared.open(outputFileURL)
    }
}
