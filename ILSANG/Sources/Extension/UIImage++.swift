//
//  UIImage++.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/1/24.
//

import UIKit

extension UIImage {
    func downSample(scale: CGFloat) -> UIImage? {
        let maxPixel = max(self.size.width, self.size.height) * scale
        let options: [CFString: Any] = [
            kCGImageSourceThumbnailMaxPixelSize: maxPixel,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: false
        ]

        guard let data = self.pngData() as CFData?,
              let imageSource = CGImageSourceCreateWithData(data, nil),
              let scaledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else {
            return nil
        }

        return UIImage(cgImage: scaledImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
