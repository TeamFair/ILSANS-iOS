//
//  MyPageBadgeList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageBadgeList: View {
    
    @ObservedObject var vm: MypageViewModel

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("총 포인트")
                
                // 프로그레스 바
                vm.ProgressBar(userXP: vm.userData?.xpPoint ?? 0)
                    .frame(height: 10)
                
                HStack {
                    Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9))")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.gray200)
                    
                    Spacer()
                    
                    Text("다음 레벨까지 \(vm.xpForNextLv(XP: vm.userData?.xpPoint ?? 50))XP 남았어요!")
                        .font(.system(size: 13))
                        .foregroundColor(.gray500)
                    
                    Spacer()
                    
                    Text("LV.\(vm.convertXPtoLv(XP: vm.userData?.xpPoint ?? 9)+1)")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accent)
                }
            }
            
            // Data List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(vm.xpLogList, id: \.recordId) { Data in
                        ListStruct(title: Data.title, detail: Data.createDate.timeAgoCreatedAt(), point: Data.xpPoint)
                    }
                }
            }
            .refreshable {
                // 데이터 리프레시
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PantagonGraph: View {
    var body: some View {
        Text("오각형")
    }
}
