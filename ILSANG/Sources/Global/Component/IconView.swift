//
//  Icon.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/23/24.
//

import SwiftUI

struct IconView: View {
    let size: IconSize
    let icon: ImageResource
    let color: IconColor
    
    var body: some View {
        Image(icon)
            .foregroundStyle(color.fgColor)
            .frame(width: size.value, height: size.value)
            .background(
                Circle()
                    .foregroundStyle(color.bgColor)
            )
    }
}

enum IconSize {
    case small
    case medium
    
    var value: CGFloat {
        switch self {
        case .small:
            26
        case .medium:
            60
        }
    }
}

enum IconColor {
    case red
    case green
    case blue
    case gray
    
    var fgColor: Color {
        switch self {
        case .red:
            return .red
        case .green:
            return .green
        case .blue:
            return .blue
        case .gray:
            return .gray300
        }
    }
    
    var bgColor: Color {
        switch self {
        case .red:
            return .badgeRed
        case .green:
            return .badgeGreen
        case .blue:
            return .badgeBlue
        case .gray:
            return .gray100
        }
    }
}
