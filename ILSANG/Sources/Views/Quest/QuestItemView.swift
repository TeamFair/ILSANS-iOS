//
//  QuestItemView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import SwiftUI

struct QuestItemView: View {
    let quest: Quest
    
    private let separatorOffset = 80.0
    
    var body: some View {
        HStack(spacing: 0) {
            Circle()
                .foregroundColor(.gray100)
                .frame(width: 60, height: 60)
                .overlay(alignment: .center) {
                    Image(uiImage: quest.missionImage)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(30)
                }
                .padding(.leading, 20)
                .padding(.trailing, 16)
                .overlay(alignment: .top) {
                    Text(String(quest.reward) + "XP")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundStyle(.primaryPurple)
                        )
                        .offset(x: 20, y: 2)
                }
            
            VStack(alignment: .leading, spacing: 4){
                Text(quest.missionTitle)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)

                Text(quest.missionCompany)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
            }
            .opacity(quest.status == .ACTIVE ? 1.0 : 0.2)
            .padding(.top, 6)
            
            Spacer()
            
            Group {
                switch quest.status {
                case .ACTIVE:
                    IconView(iconWidth: 12, size: .small, icon: .arrowDown, color: .gray)
                case .INACTIVE:
                    VStack(spacing: 7) {
                        IconView(iconWidth: 13, size: .small, icon: .check, color: .green)
                        Text("적립완료")
                            .font(.system(size: 10, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.green)
                    }
                }
            }
            .frame(width: separatorOffset, height: 103)
        }
        .frame(height: 103)
        .background(.white)
        .overlay(alignment: .trailing) {
            VLine()
                .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [3.3]))
                .frame(width: 0.5)
                .foregroundStyle(.gray200)
                .offset(x: -separatorOffset)
                .padding(.vertical, 12)
        }
        .disabled(quest.status == .ACTIVE)
        .cornerRadius(16)
        .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 20)
    }
}


#Preview {
    VStack {
        QuestItemView(quest: Quest(id: "12", missionImage: .checkmark, missionTitle: "아메리카노 5잔 마시기", missionCompany: "이디야커피", reward: 50, status: .ACTIVE))
        QuestItemView(quest: Quest(id: "13", missionImage: .checkmark, missionTitle: "아메리카노 15잔 마시기", missionCompany: "이디야커피", reward: 50, status: .INACTIVE))
    }
}


struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        return path
    }
}
