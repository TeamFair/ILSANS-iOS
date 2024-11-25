//
//  MypageShareImage.swift
//  ILSANG
//
//  Created by Kim Andrew on 11/25/24.
//

import SwiftUI

struct MypageShareImage: View {
    let xpPoint: String
    let userLV: Int
    let nextLV: Int
    let gapLV: (currentLevelXP: Int, nextLevelXP: Int)
    let xpStats: [XpStat: Int]
    
    @State private var touchedIdx: Int? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4){
                Text("총 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                Text("\(xpPoint)XP")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray500)
                
                // 프로그레스 바
                ProgressBar(levelData: gapLV)
                    .frame(height: 10)
                    .padding(.top, 10)
                
                HStack {
                    Text("LV.\(userLV)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.gray200)
                    
                    Spacer()
                    
                    Text("다음 레벨까지 \(nextLV)XP 남았어요!")
                        .font(.system(size: 13))
                        .foregroundColor(.gray500)
                    
                    Spacer()
                    
                    Text("LV.\(userLV + 1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accent)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 24) {
                Text("능력별 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                PentagonGraph(xpStats: xpStats, width: 185, mainColor: .primaryPurple, subColor: .gray300, maxValue: Double(60 + userLV))
                
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 18)
            .background(.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

extension MypageShareImage {
    private func ProgressBar(levelData: (currentLevelXP: Int, nextLevelXP: Int)) -> some View {
        let progress = calculateProgress(userXP: levelData.currentLevelXP, levelXP: levelData.nextLevelXP)
        
        return GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .cornerRadius(6)
                    .foregroundColor(.gray100)
                
                Rectangle()
                    .frame(width: CGFloat(progress) * geometry.size.width, height: 8)
                    .cornerRadius(6)
                    .foregroundColor(.accentColor)
            }
            .onAppear {
                Log("Progress: \(progress)")
            }
        }
    }
    
    private func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
    }
    
    //MAX 값은 기본 60 + 레벨 * 10
    private func PentagonGraph(xpStats: [XpStat: Int], width: CGFloat, mainColor: Color, subColor: Color, maxValue: Double) -> some View {
        HStack {
            Spacer()
            
            ZStack {
                BackgroundPolygons(width: width, subColor: subColor) // 배경 오각형
                StatPolygon(xpStats: xpStats, maxValue: maxValue, cornerRadius: 15) // 데이터 오각형
                    .fill(mainColor)
                    .opacity(0.8)
                
                StatLabels(width: width, subColor: subColor) // 능력치 레이블
            }
            .frame(width: width, height: width)
            
            Spacer()
        }
    }

    // 배경 오각형 뷰
    private func BackgroundPolygons(width: CGFloat, subColor: Color) -> some View {
        ZStack {
            Polygon(count: 5, relativeCornerRadius: 0.20)
                .stroke(.gray300, lineWidth: 1)
                .frame(width: width, height: width)
            
            Polygon(count: 5, relativeCornerRadius: 0.20)
                .stroke(.gray100, lineWidth: 1)
                .frame(width: width * 0.9, height: width * 0.9)
            
            Polygon(count: 5, relativeCornerRadius: 0.20)
                .stroke(.gray100, lineWidth: 1)
                .frame(width: width * 0.5, height: width * 0.5)
        }
    }

    // 능력치 레이블 위치 지정
    private func StatLabels(width: CGFloat, subColor: Color) -> some View {
        ForEach(Array(XpStat.sortedStat.enumerated()), id: \.element) { index, stat in
            let angle = (CGFloat(index) / CGFloat(XpStat.sortedStat.count)) * 2 * .pi - .pi / 2
            let radius = width / 2 + 30
            let labelPoint = CGPoint(
                x: width / 2 + radius * cos(angle),
                y: width / 2 + radius * sin(angle) + 10
            )
            
            PentagonStat(xpStat: stat)
                .font(.caption)
                .foregroundColor(subColor)
                .position(x: labelPoint.x, y: labelPoint.y)
                .onTapGesture {
                    touchedIdx = (touchedIdx == index) ? nil : index
                }
            
            if touchedIdx == index, let point = xpStats[stat] {
                StatLabel(stat: stat, statPoint: point)
                    .position(x: labelPoint.x, y: labelPoint.y - 30)
            }
        }
    }

    private func calculateAngle(index: Int, totalCount: Int) -> CGFloat {
        return (CGFloat(index) / CGFloat(totalCount)) * 2 * .pi - .pi / 2
    }

    private func calculateLabelPosition(width: CGFloat, angle: CGFloat) -> CGPoint {
        let radius = width / 2 + 30
        return CGPoint(
            x: width / 2 + radius * cos(angle),
            y: width / 2 + radius * sin(angle) + 10
        )
    }

    // 능력치 레이블 뷰
    private func PentagonStat(xpStat: XpStat) -> some View {
        HStack (spacing: 5) {
            Image(xpStat.image)
                .frame(height: 30)
            Text(xpStat.headerText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.gray500)
        }
    }
    
    // 능력치 스텟 뷰
    private func StatLabel(stat: XpStat, statPoint: Int) -> some View {
        VStack(spacing: 0) {
            Text("\(stat.headerText): \(statPoint) P")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.accent)
                .cornerRadius(8)
            
            Polygon(count: 3, cornerRadius: 2)
                .frame(width: 22, height: 28)
                .foregroundColor(.accent)
                .offset(y: 10)
                .rotationEffect(.degrees(180))
        }
    }
    
    func xpGapBtwLevels(XP: Int) -> (currentLevelXP: Int, nextLevelXP: Int) {
        let sanitizedXP = max(0, XP)
        
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevelXP = 50 * (currentLevel + 1)
        
        var totalXP = 0
        
        if currentLevel > 0 {
            for n in 1..<currentLevel + 1 {
                totalXP += 50 * n
            }
        }
        
        return (sanitizedXP - totalXP, nextLevelXP)
    }
    
    //XP를 레벨로 변경
    func convertXPtoLv(XP: Int) -> Int {
        var totalXP = 0
        var level = 0
        
        while totalXP <= XP {
            level += 1
            totalXP += 50 * level
        }
        
        return max(0, level - 1)
    }
}
