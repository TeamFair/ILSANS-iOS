//
//  SettingAlertView.swift
//  ILSANG
//
//  Created by Kim Andrew on 6/27/24.
//

import SwiftUI

struct SettingAlertView: View {
    
    var alertStatus: AlertStatus
    var onCancel: (() -> Void?)? = nil
    var onConfirm: (() -> Void?)? = nil
    
    var body: some View {
        VStack (alignment: .center, spacing: 6) {
            Text(alertStatus.title)
                .font(.system(size: 18))
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            if (alertStatus.subtitle != nil) {
                Text(alertStatus.subtitle ?? "")
                    .font(.system(size: 13))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
                    .padding(.horizontal, 16)
            }
            
            HStack (spacing: 10) {
                Text(alertStatus.disagree)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: 140, maxHeight: 50)
                    .background(.gray100)
                    .cornerRadius(12)
                    .onTapGesture { self.onCancel?() }
                
                Text(alertStatus.agree)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 140, maxHeight: 50)
                    .background(.accent)
                    .cornerRadius(12)
                    .onTapGesture { self.onConfirm?() }
                
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 16)
        .padding(.top, 28)
        .padding(.bottom, 16)
        .background(.white)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

enum AlertStatus {
    case NickName
    case Logout
    case Withdrawal
    
    var title: String {
        switch self {
        case .NickName:
            "닉네임 변경을 취소할까요?"
        case .Logout:
            "로그아웃 하시겠어요?"
        case .Withdrawal:
            "정말 탈퇴하시겠어요?"
        }
    }
    
    var subtitle: String? {
        switch self {
        case .NickName:
            "변경을 완료하지 않으면\n프로필이 저장되지 않습니다."
        case .Logout:
            nil
        case .Withdrawal:
            "확인 시 일상 계정이 영구적으로 삭제되며,\n모든 데이터는 복구가 불가능합니다."
        }
    }
    
    var disagree: String {
        switch self {
        case .NickName,.Withdrawal:
            "취소"
        case .Logout:
            "아니요"
        }
    }
    
    var agree: String {
        switch self {
        case .NickName,.Withdrawal:
            "확인"
        case .Logout:
            "예"
        }
    }
}

#Preview {
    VStack{
        SettingAlertView(alertStatus: .Logout,onCancel: {print("Yes")},onConfirm: {print("NO")})
        SettingAlertView(alertStatus: .NickName,onCancel: {print("Yes")},onConfirm: {print("NO")})
        SettingAlertView(alertStatus: .Withdrawal,onCancel: {print("Yes")},onConfirm: {print("NO")})
    }
}
