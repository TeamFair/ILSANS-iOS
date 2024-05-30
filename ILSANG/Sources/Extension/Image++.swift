//
//  Image++.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/30/24.
//

import SwiftUI

extension Image {
    @MainActor func getUIImage(scale displayScale: CGFloat = 1.0) -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = displayScale        
        return renderer.uiImage
    }
}
