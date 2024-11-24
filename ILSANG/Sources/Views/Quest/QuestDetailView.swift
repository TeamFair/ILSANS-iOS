//
//  QuestDetailView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 11/23/24.
//

import SwiftUI

struct QuestDetailView: View {
    let quest: QuestViewModelItem
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 30, height: 4)
                .foregroundStyle(.gray100)
                .padding(.top, 8)
                .padding(.bottom, 14)

            Text("퀘스트 정보")
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 32)
            
            questInfoView
            
            Divider()
                .foregroundStyle(.gray100)
                .padding(.top, 16)
                .padding(.bottom, 32)

            statTagViewList
            
            Text("퀘스트를 수행하셨나요?\n인증 후 포인트를 적립받으세요")
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.vertical, 10)
            
            Spacer(minLength: 0)
            
            PrimaryButton(title: "퀘스트 인증하기") {
                action()
            }
        }
        .foregroundStyle(.gray500)
        .padding(.horizontal, 20)
    }
    
    private var questInfoView: some View {
        HStack(spacing: 8) {
            Image(uiImage: quest.image ?? .logo)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 0 ) {
                Text(quest.writer)
                    .font(.system(size: 15, weight: .regular))
                    .frame(height: 30)
                
                Text(quest.missionTitle)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(2)
                    .kerning(-0.3)
                    .frame(minHeight: 30)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer(minLength: 0)
            
            Text(String(quest.totalRewardXP()) + "XP")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(.primaryPurple)
                .padding(.vertical, 12)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.primary100)
                )
        }
    }
    
    private var statTagViewList: some View {
        HStack(spacing: 12) {
            ForEach(Array(XpStat.sortedStat), id: \.rawValue) { stat in
                let point = quest.rewardDic[stat, default: 0]
                if point > 0 {
                    statTagView(stat: stat, point: point)
                }
            }
        }
        .padding(.bottom, 7)
    }
    private func statTagView(stat: XpStat, point: Int) -> some View {
        VStack(spacing: 0) {
            Text(stat.headerText)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.gray500)
                .padding(.vertical, 4)
                .frame(width: 60)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(Color.background)
                )
                .padding(.bottom, 8)
            
            VStack(spacing: 0) {
                Image(stat.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .frame(width: 48, height: 48)
                
                HStack(spacing: 0) {
                    Text("\(point)P")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(.primaryPurple)
                    Spacer(minLength: 0)
                    Image(.arrowUp)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12)
                }
                .frame(width: 56, height: 20)
            }
            .padding(.vertical, 6)
        }
    }
}

#Preview {
    QuestDetailView(quest: .mockData, action: { })
}
