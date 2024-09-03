//
//  OpenSourceInfoView.swift
//  ILSANG
//
//  Created by Kim Andrew on 9/3/24.
//

import SwiftUI

struct OpenSourceInfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationTitleView(title: "약관 및 정책", isSeparatorHidden: true) {
                dismiss()
            }
            
        }
    }
}

#Preview {
    OpenSourceInfoView()
}
