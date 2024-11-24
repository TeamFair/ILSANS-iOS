//
//  MyPageBadgeList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageBadgeList: View {
    
    let xpPoint: Int
    let userLV: Int
    let nextLV: Int
    let gapLV: (currentLevelXP: Int, nextLevelXP: Int)
    let xpStats: [XpStat: Int]

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 4){
                Text("총 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                Text("\(String(xpPoint).formatNumberInText())XP")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray500)
                
                // 프로그레스 바
                ProgressBar(userXP: gapLV)
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
                    
                    Text("LV.\(nextLV + 1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accent)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 24){
                Text("능력별 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                PentagonGraph(xpStats: xpStats, width: 185, mainColor: .primaryPurple, subColor: .gray300, maxValue: Double(60 + userLV))
                
                ShareLink(
                    item: ShareImage,
                    preview: SharePreview("프로필 공유", image: ShareImage)
                ) {
                    PrimaryButton(title: "공유하기", action: {Log("공유하기 버튼")})
                }
            }
            .padding(.horizontal, 19)
            .padding(.vertical, 18)
            .background(.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
   
}

extension MyPageBadgeList {
    func ProgressBar(userXP: (currentLevelXP: Int, nextLevelXP: Int)) -> some View {
        let levelData = userXP
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
    
    func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
    }
    
    //MAX 값은 기본 60 + 레벨 * 10
    func PentagonGraph(xpStats: [XpStat: Int], width: CGFloat, mainColor: Color, subColor: Color, maxValue: Double) -> some View {
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
    func BackgroundPolygons(width: CGFloat, subColor: Color) -> some View {
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
    func StatLabels(width: CGFloat, subColor: Color) -> some View {
        ForEach(Array(XpStat.allCases.enumerated()), id: \.element) { index, stat in
            let angle = (CGFloat(index) / CGFloat(XpStat.allCases.count)) * 2 * .pi - .pi / 2
            let radius = width / 2 + 20 // 레이블을 표시할 위치의 반지름
            let labelPoint = CGPoint(
                x: width / 2 + radius * cos(angle),
                y: width / 2 + radius * sin(angle)
            )
            
            @State var isTouched: Bool = false
            
            self.PentagonStat(xpStat: stat)
                .font(.caption)
                .foregroundColor(subColor)
                .position(x: labelPoint.x, y: labelPoint.y)
                .onTapGesture{}
            
            self.StatLabel(xpStat: stat, isTouched: isTouched)
                .font(.caption)
                .foregroundColor(subColor)
                .position(x: labelPoint.x, y: labelPoint.y + 100)
                .onTapGesture{isTouched.toggle()}
        }
    }

    // 능력치 레이블 뷰
    func PentagonStat(xpStat: XpStat) -> some View {
        HStack (spacing: 5) {
            Image(xpStat.image)
                .frame(height: 30)
            Text(xpStat.headerText)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.gray500)
        }
    }
    
    // 능력치 스텟 뷰
    func StatLabel(xpStat: XpStat, isTouched: Bool) -> some View {
        VStack(spacing: 0) {
            Text(xpStat.headerText)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.white)
                .cornerRadius(8)
            
            Polygon(count: 3, cornerRadius: 2)
                .frame(width: 20, height: 10)
                .offset(y: -1)
                .rotationEffect(.degrees(180))
        }
        .opacity(isTouched ? 1 : 0)
    }
    
    //공유하기 기능 구현
    private var ShareImage: TransferableUIImage {
        return .init(uiimage: ProfileShareImage, caption: "개인 프로파일 공유하기")
    }
    
    private var ProfileShareImage: UIImage {
        let renderer = ImageRenderer(content:   MyPageBadgeList(
            xpPoint: xpPoint,
            userLV: userLV,
            nextLV: nextLV,
            gapLV:  gapLV,
            xpStats: xpStats)
            .frame(width: 300))
        
        renderer.scale = 3.0
        return renderer.uiImage ?? .init()
    }
}
