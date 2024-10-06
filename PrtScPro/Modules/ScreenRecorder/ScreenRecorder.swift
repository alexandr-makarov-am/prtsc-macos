//
//  ScreenRecorder.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import Foundation
import ScreenCaptureKit
import AVFoundation
import AppKit
import VideoToolbox

class ScreenRecorder: NSObject, SCStreamDelegate, SCStreamOutput {
    
    private let videoSampleBufferQueue = DispatchQueue(label: "ScreenRecorder.VideoSampleBufferQueue")
    private var stream: SCStream?
    private var assetWriter: AVAssetWriter?
    private var videoInput: AVAssetWriterInput?
    private var oneFrame: Bool = false
    
    init(rect: CGRect, fps: Int = 24, oneFrame: Bool = false) {
        self.oneFrame = oneFrame
        super.init()
        self.getDisplay { display in
            if let d = display {
                let filter = SCContentFilter(display: d, excludingWindows: [])
                let conf = SCStreamConfiguration()
                conf.queueDepth = 6
                conf.sourceRect = rect
                conf.width = Int(rect.width)
                conf.height = Int(rect.height)
                conf.pixelFormat = kCVPixelFormatType_32BGRA // 'BGRA'
                conf.colorSpaceName = CGColorSpace.sRGB
                conf.minimumFrameInterval = CMTime(value: 1, timescale: CMTimeScale(fps))
                self.stream = SCStream(filter: filter, configuration: conf, delegate: self)
                do {
                    try self.stream?.addStreamOutput(self, type: .screen, sampleHandlerQueue: self.videoSampleBufferQueue)
                } catch {
                    print("error", error)
                }
            }
        }
        if !oneFrame {
            DispatchQueue.global(qos: .userInitiated).async {
                if let url = self.getStorageFolder("recording \(Date()).mov") {
                    do {
                        self.assetWriter = try AVAssetWriter(url: url, fileType: .mov)
                        self.videoInput = AVAssetWriterInput(mediaType: .video, outputSettings: nil)
                        self.videoInput?.expectsMediaDataInRealTime = true
                        self.assetWriter?.add(self.videoInput!)
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
    private func getStorageFolder(_ filename: String) -> URL? {
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        if let folder = urls.first {
            return folder.appendingPathComponent(filename)
        }
        return nil
    }
    
    private func getDisplay(completion: @escaping (_ display: SCDisplay?) -> Void) {
        SCShareableContent.getCurrentProcessShareableContent { content, error in
            if error == nil {
                let mainDisplay = content?.displays.filter({ display in
                    return display.displayID == CGMainDisplayID()
                })
                completion(mainDisplay?.first)
            }
        }
    }
    
    private func startSession() {
        assetWriter?.startWriting()
        assetWriter?.startSession(atSourceTime: CMClock.hostTimeClock.time)
    }
    
    private func stopSession() async {
        assetWriter?.endSession(atSourceTime: CMClock.hostTimeClock.time)
        videoInput?.markAsFinished()
        await assetWriter?.finishWriting()
    }
    
    public func record() {
        self.startSession()
        stream?.startCapture()
    }
    
    public func stop() async {
        do {
            try await stream?.stopCapture()
            await self.stopSession()
        } catch {
            print(error)
        }
    }
    
    private func saveScreenShot(buffer: CVImageBuffer)  throws  {
        guard let url = getStorageFolder("\(Date()).jpg") else { return }
        let ciimage = CIImage(cvPixelBuffer: buffer)
        let context = CIContext(options: nil)
        if let cgImage = context.createCGImage(ciimage, from: ciimage.extent) {
            let nsImage = NSImage(cgImage: cgImage, size: ciimage.extent.size)
            guard let tiff = nsImage.tiffRepresentation else { return }
            let bitmap = NSBitmapImageRep(data: tiff)
            if let data = bitmap?.representation(using: .jpeg, properties: [:]) {
                try data.write(to: url)
            }
        }
    }
    
    func stream(_ stream: SCStream, didOutputSampleBuffer sampleBuffer: CMSampleBuffer, of type: SCStreamOutputType) {
        guard sampleBuffer.isValid else { return }
        switch type {
        case .screen:
            if oneFrame {
                if let iss = CMSampleBufferGetImageBuffer(sampleBuffer) {
                    do {
                        print("save")
                        try saveScreenShot(buffer: iss)
                    } catch {
                        print(error)
                    }
                }
                Task.detached(priority: .userInitiated) {
                    await self.stop()
                }
            } else {
                videoInput?.append(sampleBuffer)
            }
            break
        default:
            break
        }
    }
}
