//
//  MyPageBadgeList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageBadgeList: View {
    
    @ObservedObject var vm: MypageViewModel
    
    @State private var touchedIdx: Int? = nil
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4){
                    Text("총 포인트")
                        .font(.system(size: 12))
                        .foregroundColor(.gray400)
                    
                    Text("\(String(vm.userData?.xpPoint ?? 150).formatNumberInText())XP")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.gray500)
                    
                    // 프로그레스 바
                    ProgressBar(userXP: vm.userData?.xpPoint ?? 0)
                        .frame(height: 10)
                        .padding(.top, 10)
                    
                    HStack {
                        Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9))")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.gray200)
                        
                        Spacer()
                        
                        Text("다음 레벨까지 \(vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50))XP 남았어요!")
                            .font(.system(size: 13))
                            .foregroundColor(.gray400)
                        
                        Spacer()
                        
                        Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9)+1)")
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
                    
                    PentagonGraph(xpPoint: vm.userData?.xpPoint ?? 10, xpStats: vm.xpStats, width: 185, mainColor: .primaryPurple, subColor: .gray300, maxValue: Double(60 + vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 0)))
                    
                    ShareLink(
                        item: ShareImage,
                        preview: SharePreview("프로필 공유", image: ShareImage.image)
                    ) {
                        Text("공유하기")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .padding(.top, 27)
                    }
                    
                }
                .padding(.horizontal, 19)
                .padding(.vertical, 18)
                .background(.white)
                .cornerRadius(12)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
            StatLabels(width: 180, subColor: .primaryPurple)
                .zIndex(3)
        }
    }
}

extension MyPageBadgeList {
    private func ProgressBar(userXP: Int) -> some View {
        let levelData = vm.xpGapBtwLevels(XP: userXP)
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
        }
    }
    
    private func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
    }
    
    private func PentagonGraph(xpPoint:Int, xpStats: [XpStat: Int], width: CGFloat, mainColor: Color, subColor: Color, maxValue: Double) -> some View {
        HStack {
            Spacer()
            
            ZStack {
                BackgroundPolygons(width: width, subColor: subColor) // 배경 오각형
                if xpPoint != 0 {
                    StatPolygon(xpStats: xpStats, maxValue: maxValue, cornerRadius: 15) // 데이터 오각형
                        .fill(mainColor)
                        .opacity(0.8)

                    StatLabels(width: width, subColor: subColor) // 능력치 레이블
                }
            }
            .frame(width: width, height: width)
            
            Spacer()
        }
    }

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

    private func StatLabels(width: CGFloat, subColor: Color) -> some View {
        ForEach(Array(XpStat.allCases.enumerated()), id: \.element) { index, stat in
            let angle = calculateAngle(index: index, totalCount: XpStat.sortedStat.count)
            let labelPoint = calculateLabelPosition(width: width, angle: angle)

            ZStack {
                PentagonStat(xpStat: stat)
                    .font(.caption)
                    .foregroundColor(subColor)
                    .position(x: labelPoint.x, y: labelPoint.y)
                    .onTapGesture {
                        touchedIdx = (touchedIdx == index) ? nil : index
                    }

                if touchedIdx == index, let point = vm.xpStats[stat] {
                    StatLabel(stat: stat, statPoint: point)
                        .position(x: labelPoint.x, y: labelPoint.y - 25) // 위치 조정
                        .zIndex(1)
                }
            }
            .padding(.top, 20)
        }
        .frame(width: width, height: width, alignment: .center)
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

    private func PentagonStat(xpStat: XpStat) -> some View {
        HStack(spacing: 5) {
            Image(xpStat.image)
                .frame(height: 30)
            Text(xpStat.headerText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.gray500)
        }
    }
    
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
    
    private var ShareImage: TransferableUIImage {
        return .init(uiimage: ProfileShareImage, caption: "마이페이지 공유하기")
    }
    
    private var ProfileShareImage: UIImage {
        let renderer = ImageRenderer(content: MypageShareImage(
            xpPoint: String(vm.userData?.xpPoint ?? 0).formatNumberInText(),
            userLV: vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 0),
            nextLV: vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50),
            gapLV:  vm.xpGapBtwLevels(XP: vm.userData?.xpPoint ?? 0),
            xpStats: vm.xpStats)
            .frame(width: 300))
        
        renderer.scale = 3.0
        return renderer.uiImage ?? .init()
    }
}
