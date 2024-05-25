//
//  SubmitAlertView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/25/24.
//

import SwiftUI

struct SubmitAlertView: View {
    @State var status: SubmitStatus
    
    var body: some View {
        VStack(spacing: 0) {
            IconView(iconWidth: status.iconWidth, size: .medium, icon: status.icon, color: status.color)
                .padding(.bottom, 15)

            Text(status.title)
                .foregroundColor(.gray400)
                .font(.system(size: 17, weight: .bold))
                .padding(.bottom, 9)

            Text(status.subtitle)
                .foregroundColor(.gray300)
                .font(.system(size: 15, weight: .regular))
                .padding(.bottom, 4)

            PrimaryButton(title: "확인") {
                print("close")
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
            "다시 시도해보세요🥲"
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
        SubmitAlertView(status: .complete)
        SubmitAlertView(status: .fail)
        SubmitAlertView(status: .submit)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.secondary)
}
