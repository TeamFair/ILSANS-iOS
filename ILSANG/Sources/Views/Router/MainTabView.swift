//
//  MainTabView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: Tab = .quest
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(Tab.allCases, id: \.self) { tab in
                createTabView(for: tab)
                    .tabItem {
                        Image(systemName: tab == selectedTab ? (tab.icon + ".fill") : tab.icon)
                        Text(tab.title)
                    }
                    .tag(tab)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func createTabView(for tab: Tab) -> some View {
        switch tab {
        case .quest:
            QuestView()
        case .approval:
            ApprovalView()
        case .mypage:
            MyPageView()
        }
    }
}
