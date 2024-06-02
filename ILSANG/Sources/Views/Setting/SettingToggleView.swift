//
//  SettingToggleView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/29/24.
//

import SwiftUI

struct SettingToggleView: View {
    let title : String
    let subTitle : String
    
    @State private var isOn: Bool = false
    
    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                // 타이틀
                Text("\(title)")
                // 서브 타이틀
                Text("\(subTitle)")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
        }
        .toggleStyle(SwitchToggleStyle(tint: .black))
        .padding()
    }
}
