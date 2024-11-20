//
//  MypageViewModel.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/25/24.
//

import SwiftUI

final class MypageViewModel: ObservableObject {
    
    @Published var segmentSelect = 0
    
    @Published var userData: User?
    @Published var xpStats: [XpStat: Int] = [:]
    @Published var xpLogList: [XPContent] = []
    @Published var challengeList: [Challenge] = []
    
    @Published var challengeDelete = false
    
    let mockXpStats: [XpStat: Int] = [
        .strength: 0,
        .intellect: 10,
        .fun: 20,
        .charm: 30,
        .sociability: 40
    ]
    
    private let userNetwork: UserNetwork
    private let challengeNetwork: ChallengeNetwork
    private let imageNetwork: ImageNetwork
    private let xpNetwork: XPNetwork
    
    init(userData: User? = nil, userNetwork: UserNetwork, challengeNetwork: ChallengeNetwork, imageNetwork: ImageNetwork, xpNetwork: XPNetwork) {
        self.userData = userData
        self.userNetwork = userNetwork
        self.challengeNetwork = challengeNetwork
        self.imageNetwork = imageNetwork
        self.xpNetwork = xpNetwork
    }
    
    @MainActor
    func getUser() async {
        let res = await userNetwork.getUser()
        
        switch res {
        case .success(let model):
            self.userData = model.data
            Log(model.data)
            
        case .failure:
            self.userData = nil
            Log(res)
        }
    }
    
    @MainActor
    func getxpLog(page: Int, size: Int) async {
        let res = await xpNetwork.getXP(page: page, size: 10)
        
        switch res {
        case .success(let model):
            self.xpLogList = model.data
            
        case .failure:
            self.xpLogList = []
            Log(res)
        }
    }
    
    @MainActor
    func getXpStat() async {
        let res = await xpNetwork.getXpStats()
        
        switch res {
        case .success(let model):
            let xpData = model.data
            self.xpStats = [
                .strength: xpData.strengthStat,
                .intellect: xpData.intellectStat,
                .fun: xpData.funStat,
                .charm: xpData.charmStat,
                .sociability: xpData.sociabilityStat
            ]
            Log(xpStats)
            
        case .failure:
            self.xpStats = [:]
        }
    }
    
    @MainActor
    func getChallenges(page: Int) async {
        let Data = await challengeNetwork.getChallenges(page: page)
        
        switch Data {
        case .success(let model):
            self.challengeList = model.data
            Log(self.challengeList)

        case .failure:
            self.challengeList = []
        }
    }
    
    @MainActor
    func updateChallengeStatus(challengeId: String, ImageId: String) async -> Bool {
        let deleteChallengeRes = await challengeNetwork.deleteChallenge(challengeId: challengeId)
        let deleteImageRes = await imageNetwork.deleteImage(imageId: ImageId)
        
        Log(deleteChallengeRes); Log(deleteImageRes)
        
        return deleteChallengeRes && deleteImageRes
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
    
    //이전,다음 레벨 XP
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
    
    //다음 레벨까지 남은 값 
    func xpForNextLv(XP: Int) -> Int {
        let sanitizedXP = max(0, XP)
        let currentLevel = convertXPtoLv(XP: sanitizedXP)
        let nextLevel = currentLevel + 1
        var totalXP = 0
        
        for n in 1...nextLevel {
            totalXP += 50 * n
        }
        
        Log(totalXP)
        return totalXP - sanitizedXP
    }
    
    func getImage(imageId: String) async -> UIImage? {
        await ImageCacheService.shared.loadImageAsync(imageId: imageId)
    }
    
    func ProgressBar(userXP: Int) -> some View {
        let levelData = xpGapBtwLevels(XP: userXP)
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
                Log(self.xpGapBtwLevels(XP: userXP).currentLevelXP)
                Log(self.xpGapBtwLevels(XP: userXP).nextLevelXP)
            }
        }
    }
    
    func calculateProgress(userXP: Int, levelXP: Int) -> Double {
        guard levelXP != 0 else { return 0 }
        return Double(userXP) / Double(levelXP)
    }
    
    //MAX 값은 기본 50 + 레벨 * 10
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
}

extension ChangeNickNameView {
    func isValidNickname(_ name: String) -> Bool {
        let language = ".*[가-힣a-zA-Z0-9]+.*"
        let isMatche = NSPredicate(format: "SELF MATCHES %@", language).evaluate(with: name)
        let isValidLength = (2...12).contains(name.count)
        
        return isMatche && isValidLength
    }
}
