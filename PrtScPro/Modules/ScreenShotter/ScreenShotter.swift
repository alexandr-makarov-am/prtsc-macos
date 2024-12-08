//
//  ScreenShotter.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 4.12.24.
//

import Foundation
import ScreenCaptureKit

class ScreenShotter: NSObject {
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
    private func getStorageFolder(_ filename: String) -> URL? {
        let urls = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
        if let folder = urls.first {
            return folder.appendingPathComponent(filename)
        }
        return nil
    }
    private func saveScreenShot(buffer: CGImage) {
        guard let url = getStorageFolder("\(AppUtils.getUniqueFilename()).jpg") else { return }
        let bitmap = NSBitmapImageRep(cgImage: buffer)
        if let data = bitmap.representation(using: .jpeg, properties: [:]) {
            do {
                try data.write(to: url)
                NSWorkspace.shared.open(url)
            } catch {
                print(error)
            }
        }
    }
    public func take(rect: CGRect) {
        self.getDisplay { display in
            if let d = display {
                let _rect = AppUtils.convertRectCoords(rect, display: d);
                let filter = SCContentFilter(display: d, excludingWindows: [])
                let conf = SCStreamConfiguration()
                conf.sourceRect = _rect
                conf.width = Int(_rect.width) * 2
                conf.height = Int(_rect.height) * 2
                conf.captureResolution = .best
                conf.pixelFormat = kCVPixelFormatType_32BGRA // 'BGRA'
                conf.colorSpaceName = CGColorSpace.sRGB
                SCScreenshotManager.captureImage(contentFilter: filter, configuration: conf) { data, err in
                    if err == nil {
                        guard let image = data else { return }
                        self.saveScreenShot(buffer: image)
                    }
                }
            }
        }
    }
}
