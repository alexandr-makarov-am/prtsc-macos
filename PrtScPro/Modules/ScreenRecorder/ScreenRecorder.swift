//
//  ScreenRecorder.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//
import AVFoundation
import Cocoa
import ffmpegkit

final class ScreenRecorder: NSObject {
    private let queue = DispatchQueue.global(qos: .userInteractive)
    private let input = AVCaptureScreenInput(displayID: CGMainDisplayID())
    private let output = AVCaptureMovieFileOutput()
    private let session = AVCaptureSession()
    private let semaphore = DispatchSemaphore(value: 0)
    public var recording = false
    
    override init() {}
    
    private func createTempFile(_ ext: String) -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension(ext)
    }
    
    private func createOutputFile() -> URL? {
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        if let folder = urls.first {
            return folder.appendingPathComponent("\(AppUtils.getUniqueFilename()).mp4")
        }
        return nil
    }

    func record(rect: CGRect) {
        queue.sync {
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
            session.startRunning()
            output.startRecording(to: createTempFile("mov"), recordingDelegate: self)
        }
    }
    
    func stop(_ completion: @escaping () -> Void) {
        queue.sync {
            output.stopRecording()
            session.stopRunning()
            session.removeOutput(output)
            if let input = input {
                session.removeInput(input)
            }
            DispatchQueue.global(qos: .background).async {
                self.semaphore.wait()
                DispatchQueue.main.async {
                    completion();
                }
            }
        }
    }
}

extension ScreenRecorder: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        self.recording = true
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        self.recording = false
        if let videoUrl = createOutputFile() {
            FFmpegKit.executeAsync("-i \"\(outputFileURL.relativePath)\" -c:v mpeg4 \"\(videoUrl.relativePath)\"") { res in
                if ReturnCode.isSuccess(res?.getReturnCode())  {
                    NSWorkspace.shared.open(videoUrl)
                    let fs = FileManager.default
                    do {
                        try fs.removeItem(atPath: outputFileURL.relativePath)
                        self.semaphore.signal()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
