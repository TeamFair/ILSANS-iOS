//
//  TagView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 11/3/24.
//

import SwiftUI

struct TagView: View {
    let title: String
    var image: ImageResource? = nil
    let tagStyle: TagStyle
    
    var body: some View {
        HStack(spacing: 0) {
            if let image = image {
                Image(image)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            Text(title)
                .multilineTextAlignment(.center)
        }
        .modifier(TagViewModifier(style: tagStyle))
    }
}

extension TagView {
    enum TagStyle {
        case level, levelStroke, xp, xpWithIcon, `repeat`(RepeatType)
        
        var font: Font {
            switch self {
            case .level: return .system(size: 13, weight: .bold)
            case .levelStroke: return .system(size: 13, weight: .bold)
            case .xp: return .system(size: 10, weight: .semibold)
            case .xpWithIcon: return .system(size: 12, weight: .regular)
            case .repeat: return .system(size: 10, weight: .semibold)
            }
        }
        
        var fgColor: Color {
            switch self {
            case .level: return .white
            case .levelStroke: return .primaryPurple
            case .xp: return .white
            case .xpWithIcon: return .primaryPurple
            case .repeat(let type): return type.fgColor
            }
        }
        
        var bgColor: Color {
            switch self {
            case .level: return .primaryPurple
            case .levelStroke: return .white
            case .xp: return .primaryPurple
            case .xpWithIcon: return .clear
            case .repeat: return .white
            }
        }
        
        var gradient: Gradient? {
            switch self {
            case .repeat(let type):
                return type.bgGradient
            case .level, .levelStroke, .xp, .xpWithIcon:
                return nil
            }
        }
        
        var strokeColor: Color? {
            switch self {
            case .xpWithIcon, .levelStroke: return .primaryPurple
            case .level, .xp, .repeat: return nil
            }
        }
        
        var padding: EdgeInsets {
            switch self {
            case .level: return EdgeInsets(top: 2, leading: 12, bottom: 2, trailing: 12)
            case .levelStroke: return EdgeInsets(top: 4, leading: 14.5, bottom: 4, trailing: 14.5)
            case .xp: return EdgeInsets(top: 0, leading: 7, bottom: 0, trailing: 7)
            case .xpWithIcon: return EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            case .repeat: return EdgeInsets(top: 0, leading: 11, bottom: 0, trailing: 11)
            }
        }
        
        var height: CGFloat {
            switch self {
            case .level, .levelStroke, .xp, .repeat:
                20
            case .xpWithIcon:
                25
            }
        }
        
        var cornerRadius: CGFloat {
            return 12
        }
    }
}

struct TagViewModifier: ViewModifier {
    let style: TagView.TagStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.fgColor)
            .padding(style.padding)
            .frame(height: style.height)
            .background(
                ZStack {
                    if let gradient = style.gradient {
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        style.bgColor
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.strokeColor ?? .clear, lineWidth: 1)
            )
    }
}
