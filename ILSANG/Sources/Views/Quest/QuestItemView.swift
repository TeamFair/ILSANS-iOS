//
//  QuestItemView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import SwiftUI

struct QuestItemView: View {
    let quest: QuestViewModelItem
    let status: QuestStatus
    private let separatorOffset = 72.0
    
    var body: some View {
        HStack(spacing: 0) {
            Image(uiImage: quest.image ?? .logo)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .background(Color.badgeBlue)
                .clipShape(Circle())
                .padding(.leading, 20)
                .padding(.trailing, 16)
                .overlay(alignment: .top) {
                    TagView(title: String(quest.totalRewardXP()) + "XP", tagStyle: .xp)
                        .offset(x: 20, y: 2)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(quest.missionTitle.forceCharWrapping)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Text(quest.writer)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray400)
                    .padding(.bottom, 4)
                
                if status == .uncompleted {
                    HStack(spacing: 4) {
                        ForEach(Array(XpStat.sortedStat), id: \.rawValue) { stat in
                            let reward = quest.rewardDic[stat, default: 0]
                            if reward > 0 {
                                TagView(title: "\(reward)P", image: stat.image, tagStyle: .xpWithIcon)
                            }
                        }
                    }
                }
            }
            
            Spacer(minLength: 4)
            
            Group {
                switch status {
                case .uncompleted:
                    IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
                        .padding(.trailing, 24)
                case .completed:
                    VStack(spacing: 7) {
                        IconView(iconWidth: 13, size: .small, icon: .check, color: .green)
                        Text("적립완료")
                            .font(.system(size: 12, weight: .semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.green)
                    }
                    .frame(width: separatorOffset)
                }
            }
        }
        .padding(.vertical, 24)
        .background(.white)
        .overlay(alignment: .trailing) {
            if status == .completed {
                VLine()
                    .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [3.3]))
                    .frame(width: 0.5)
                    .foregroundStyle(.gray200)
                    .offset(x: -separatorOffset)
                    .padding(.vertical, 12)
            }
        }
        .disabled(status == .uncompleted)
        .cornerRadius(status == .uncompleted ? 12 : 16)
        .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}


#Preview {
    VStack {
        QuestItemView(quest: QuestViewModelItem.mockData, status: .completed)
        QuestItemView(quest: QuestViewModelItem.mockData, status: .uncompleted)
    }
}
