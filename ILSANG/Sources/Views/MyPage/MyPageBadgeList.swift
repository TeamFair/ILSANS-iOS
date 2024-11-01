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
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4){
                Text("총 포인트")
                    .font(.system(size: 12))
                    .foregroundColor(.gray400)
                
                Text("\(String(vm.userData?.xpPoint ?? 150).formatNumberInText())XP")
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.gray500)
                
                // 프로그레스 바
                vm.ProgressBar(userXP: vm.userData?.xpPoint ?? 0)
                    .frame(height: 10)
                    .padding(.top, 14)
                
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
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(12)
            
            PantagonGraph()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PantagonGraph: View {
    var body: some View {
        Text("오각형")
    }
}
