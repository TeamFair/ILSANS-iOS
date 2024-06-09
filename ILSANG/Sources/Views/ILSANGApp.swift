//
//  ILSANGApp.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/19/24.
//

import SwiftUI

@main
struct ILSANGApp: App {
    init() {
        setTabBarAppearance()
    }
    
    @State private var isLogin: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if !isLogin {
                LoginView(isLogin: $isLogin)
            } else {
                MainTabView()
            }
        }
    }
    
    func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(.grayDD)
        appearance.stackedItemPositioning = .centered
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
