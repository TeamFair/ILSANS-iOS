//
//  MyPageSegment.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/22/24.
//

import SwiftUI

struct MyPageSegment: View {
    
    @Binding var selectedIndex: Int
    
    let items = ["퀘스트", "활동", "뱃지"]
    let icons = ["📜", "⛳️", "🎖️"]
    
    var body: some View {
        HStack (spacing: 10) {
            ForEach(0..<items.count, id: \.self) { index in
                SegmenetStruct(sgmIcon: icons[index], sgmTitle: items[index], index: index, selectedIndex: $selectedIndex)
            }
        }
        .padding(.vertical, 16)
    }
}

struct SegmenetStruct: View {
    
    let sgmIcon: String
    let sgmTitle: String
    let index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 38)
                .frame(maxWidth: .infinity)
                .background(selectedIndex == index ? Color.accentColor : Color.white)
                .cornerRadius(12)
            
            HStack(alignment: .center, spacing: 4) {
                Text(sgmIcon)
                    .font(.system(size: 11))
                
                Text(sgmTitle)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(selectedIndex == index ? Color.white : Color.gray500)
            }
        }
        .onTapGesture {
            selectedIndex = index
        }
    }
}
