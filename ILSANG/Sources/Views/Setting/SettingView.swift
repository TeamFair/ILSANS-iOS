//
//  SettingView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct SettingView: View {
    
    
    @Environment(\.dismiss) var dismiss
    
    private let settingList: [Setting] = [
        Setting(title: "고객센터",titleColor: false, arrow: true, subInfo: nil),
        Setting(title: "약관 및 정책",titleColor: false, arrow: true, subInfo: nil),
        Setting(title: "현재 버전",titleColor: false, arrow: false, subInfo: "v.0.0.1"),
        Setting(title: "로그아웃",titleColor: false, arrow: false, subInfo: nil),
        Setting(title: "회원 탈퇴",titleColor: true, arrow: true, subInfo: nil)
       ]
    
    var body: some View {
        VStack {
            
            NavigationTitleView(title: "설정") {
                dismiss()
            }
            
            List(settingList) { item in
                ZStack(alignment: .leading) {
                    HStack {
                        Text(item.title)
                            .foregroundColor(item.titleColor ? Color.red : Color.black)
                        Spacer()
                        Text(item.subInfo ?? "")
                            .foregroundColor(.gray200)
                    }
                    if item.title == "로그아웃" {
                        Button(action: {
                            // 로그아웃 함수 호출
                            
                        }) {
                            EmptyView()
                        }
                        .opacity(item.arrow ? 1 : 0)
                    } else {
                        NavigationLink(destination: destinationView(for: item)) {
                            EmptyView()
                        }
                        .opacity(item.arrow ? 1 : 0)
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    //특정 Setting에 따라서 뷰를 다르게 호출
    @ViewBuilder
       private func destinationView(for item: Setting) -> some View {
           switch item.title {
           case "고객센터":
               CustomerServiceView()
           case "약관 및 정책":
               TermsAndPolicyView()
           case "회원 탈퇴":
               DeleteAccountView()
           default:
               Text(item.subInfo ?? "")
           }
       }
}

#Preview {
    SettingView()
}