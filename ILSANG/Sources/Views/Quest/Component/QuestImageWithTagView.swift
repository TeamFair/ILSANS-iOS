//
//  QuestImageWithTagView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 12/1/24.
//

import SwiftUI

struct QuestImageWithTagView: View {
    let image: UIImage?
    let tagTitle: String
    let tagStyle: TagView.TagStyle
    let tagOffset: (x: CGFloat, y: CGFloat)
    private let imageSize: CGSize = CGSize(width: 60, height: 60)
    
    var body: some View {
        Image(uiImage: image ?? .logo)
            .resizable()
            .scaledToFit()
            .frame(width: imageSize.width, height: imageSize.height)
            .background(Color.badgeBlue)
            .clipShape(Circle())
            .overlay(alignment: .topTrailing) {
                TagView(title: tagTitle, tagStyle: tagStyle)
                    .position(x: tagOffset.x, y: tagOffset.y)
            }
    }
}
