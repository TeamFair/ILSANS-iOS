//
//  MyPageSegmenet.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/22/24.
//

import SwiftUI

struct MyPageSegmenet: View {
    
    @State private var selectedIndex = 0
    
    let items = ["퀘스트", "활동", "뱃지"]
    let icons = ["📜", "⛳️", "🎖️"]
    
    var body: some View {
        HStack (spacing: 20) {
            ForEach(0..<items.count, id: \.self) { index in
                Segmenet(sgmIcon: icons[index], sgmTitle: items[index], index: index, selectedIndex: $selectedIndex)
            }
        }
    }
}

struct Segmenet: View {
    
    let sgmIcon: String
    let sgmTitle: String
    let index: Int
    @Binding var selectedIndex: Int
    
    //MARK: 색상 변경
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 111, height: 38)
                .background(selectedIndex == index ? Color.accentColor : Color.white)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
            
            HStack {
                Text(sgmIcon)
                Text(sgmTitle)
                    .fontWeight(.bold)
                    .foregroundColor(selectedIndex == index ? Color.white : Color.gray300)
            }
            .padding()
        }
        .onTapGesture {
            selectedIndex = index
        }
    }
}

#Preview {
    MyPageSegmenet()
}
