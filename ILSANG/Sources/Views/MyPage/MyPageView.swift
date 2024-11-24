//
//  MyPageView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct MyPageView: View {
    
    @StateObject var vm: MypageViewModel = MypageViewModel(userNetwork: UserNetwork(), challengeNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork(), xpNetwork: XPNetwork())
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 프로필 제목
                HStack {
                    Text("내 프로필")
                        .font(.system(size: 21))
                        .fontWeight(.bold)
                        .foregroundColor(.gray500)
                    Spacer()
                    NavigationLink(destination: SettingView()) {
                        Image("Setting")
                            .foregroundColor(.gray500)
                    }
                }
                .frame(height: 50)
                .padding(.bottom, 5)
                
                // 개인 프로필
                MyPageProfile(vm: vm)
                
                // 퀘스트/활동/뱃지 세그먼트
                MyPageSegment(selectedIndex: $vm.segmentSelect)
                
                // 퀘스트/활동/뱃지 리스트
                switch vm.segmentSelect {
                case 0:
                    MyPageChallengeList(vm: vm)
                case 1:
                    MyPageActiveList(vm: vm)
                case 2:
                    MyPageBadgeList(
                        xpPoint: vm.userData?.xpPoint ?? 0,
                        userLV: vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 0),
                        nextLV: vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50),
                        gapLV:  vm.xpGapBtwLevels(XP: vm.userData?.xpPoint ?? 0),
                        xpStats: vm.xpStats)
                    
                default:
                    EmptyView()
                }
            }
            .padding(.horizontal, 20)
            .background(Color.background)
        }
        .task {
            await vm.getUser()
            await vm.getXpStat()
            await vm.getChallenges(page: 0)
            await vm.getxpLog(page: 0, size: 10)
        }
    }
}

struct EmptyView: View {
    var title: String = ""
    
    var body: some View {
        Text(title)
            .font(.system(size: 17))
            .fontWeight(.medium)
            .foregroundColor(.gray400)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .refreshable {
                // 데이터 리프레시
            }
    }
}
