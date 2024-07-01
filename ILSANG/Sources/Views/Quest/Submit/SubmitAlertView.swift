//
//  SubmitAlertView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/25/24.
//

import SwiftUI

struct SubmitAlertView: View {
    @ObservedObject var vm: SubmitAlertViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if vm.showSubmitAlertView {
                Color.black.opacity(0.7).ignoresSafeArea()
                
                SubmitStatusComponent(status: vm.submitStatus) {
                    vm.showSubmitAlertView = false
                    if vm.submitStatus == .complete {
                        dismiss()
                    }
                }
                .task {
                    await vm.postChallengeWithImage()
                }
            }
        }
        .onDisappear {
            vm.showSubmitAlertView = false
        }
    }
}

struct SubmitStatusComponent: View {
    let status: SubmitStatus
    var action: () -> ()

    var body: some View {
        
        VStack(spacing: 0) {
            IconView(iconWidth: status.iconWidth, size: .medium, icon: status.icon, color: status.color)
                .padding(.bottom, 15)
            
            Text(status.title)
                .foregroundColor(.gray500)
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 9)
            
            HStack(spacing: 0) {
                Text(status.subtitle)
                    .foregroundColor(.gray400)
                    .font(.system(size: 15, weight: .regular))
                Text(status.emoticon)
                    .font(.system(size: 12))
            }
            .padding(.bottom, 4)
            
            PrimaryButton(title: "확인") {
                action()
            }
            .padding(16)
            .opacity(status == .submit ? 0 : 1)
        }
        .padding(.top, status == .submit ? 90 : 30)
        .frame(width: 260, height: 240)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.white)
        )
    }
}

enum SubmitStatus {
    case submit
    case complete
    case fail
    
    var title: String {
        switch self {
        case .submit:
            "제출 중이에요"
        case .complete:
            "제출이 완료됐어요"
        case .fail:
            "제출에 실패했어요"
        }
    }
    
    var subtitle: String {
        switch self {
        case .submit, .complete:
            ""
        case .fail:
            "다시 시도해보세요"
        }
    }
    
    var emoticon: String {
        switch self {
        case .submit, .complete:
            ""
        case .fail:
            "🥲"
        }
    }
    
    var icon: ImageResource {
        switch self {
        case .submit:
            return .ellipsis
        case .complete:
            return .check
        case .fail:
            return .xmark
        }
    }
    
    var iconWidth: CGFloat {
        switch self {
        case .submit:
            return 35
        case .complete:
            return 31
        case .fail:
            return 24
        }
    }
    
    var color: IconColor {
        switch self {
        case .submit:
            return .blue
        case .complete:
            return .green
        case .fail:
            return .red
        }
    }
}

#Preview {
    VStack {
        SubmitStatusComponent(status: .submit, action: {})
        SubmitStatusComponent(status: .fail, action: {})
        SubmitStatusComponent(status: .complete, action: {})
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.secondary)
}
