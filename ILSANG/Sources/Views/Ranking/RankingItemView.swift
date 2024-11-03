//
//  RankingItemView.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import SwiftUI

struct RankingItemView: View {
    let idx: Int
    let rank: Rank
    
    var body: some View {
        HStack(spacing: 0) {
            // 랭킹 아이콘 & 순위
            if idx <= 3 {
                Image("rank\(idx)")
                    .resizable()
                    .frame(width: 26, height: 26)
            } else {
                Text("\(idx)")
                    .frame(width: 26, height: 26, alignment: .center)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundStyle(.gray500)
            }
            
            Text("😍")
                .font(.system(size: 23, weight: .bold))
                .frame(width: 48, height: 48)
                .background(
                    Circle().fill(Color.backgroundBlue)
                )
                .padding(.horizontal, UIDevice.isSEDevice ? 16 : 24)
            
            VStack (alignment: .leading, spacing: 4) {
                Text(rank.nickname)
                    .font(.system(size: 15, weight: .bold))
                Text("\(convertStat(rank.xpType)): \(rank.xpPoint)p")
                    .font(.system(size: 13))
                    .foregroundColor(.gray400)
            }
            
            Spacer(minLength: 0)
            
            // MARK: API 수정 후 태그뷰 추가
        }
        .padding(.horizontal, UIDevice.isSEDevice ? 20 : 24)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(.white)
        .cornerRadius(16)
        .padding(.horizontal, 20)
    }
}

extension RankingItemView {
    //XpStat 한글 변환
    func convertStat(_ xpType: String) -> String {
        let typeMapping: [String: String] = [
            "STRENGTH": "체력",
            "INTELLECT": "지능",
            "FUN": "재미",
            "CHARM": "매력",
            "SOCIABILITY": "사회성"
        ]
    
        return typeMapping[xpType] ?? xpType
    }
}
