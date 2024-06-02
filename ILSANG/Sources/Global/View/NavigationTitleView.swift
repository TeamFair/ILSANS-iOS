//
//  NavigationTitleView.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/30/24.
//

import SwiftUI

struct NavigationTitleView: View {
    let title: String
    var isSeparatorHidden = false
    var isDismissButtonHidden = false
    var action: (() -> Void?)? = nil
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                if !isDismissButtonHidden {
                    Button {
                        self.action?()
                    } label: {
                        DismissButton()
                    }
                }
            }
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .frame(height: 45)
            .background(Color.white)
        
        if !isSeparatorHidden {
            SeparatorView()
        }
    }
}

struct SeparatorView: View {
    var body: some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 0.5)
            .foregroundStyle(Color.gray100)
    }
}

struct DismissButton: View {
    var body: some View {
        Image(systemName: "chevron.left")
            .foregroundColor(.black)
    }
}
