//
//  TitleWithContentView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/28/24.
//

import SwiftUI

struct TitleWithContentView<Content: View>: View {
    let title: String
    var seeAll: (type: SeeAllType, alignment: SeeAllAlignment, action: () -> ())? = nil
    let content: Content

    enum SeeAllAlignment {
        case topTrailing
        case bottomTrailing
    }
    
    enum SeeAllType {
        case icon
        case label(String)
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .icon:
                Image(.arrowRight)
                    .scaledToFit()
                    .frame(width: 8)
                    .foregroundStyle(.gray500)
                    .frame(width: 18, height: 18)
            case .label(let title):
                HStack(spacing: 0) {
                    Text(title)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 7)
                        .frame(width: 20, height: 20)
                }
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.gray500)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title.forceCharWrapping)
                    .font(.system(size: 19, weight: .bold))
                Spacer(minLength: 0)
                if seeAll?.alignment == .topTrailing {
                    Button {
                        seeAll?.action()
                    } label: {
                        seeAll?.type.view
                    }
                }
            }
            .padding(.horizontal, 20)
            
            content
            
            HStack {
                Spacer(minLength: 0)
                if seeAll?.alignment == .bottomTrailing {
                    Button {
                        seeAll?.action()
                    } label: {
                        seeAll?.type.view
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func seeAllBtn(title:String, action: () -> ()) -> some View {
        Text(title)
            .font(.system(size: 19, weight: .bold))
    }
}
