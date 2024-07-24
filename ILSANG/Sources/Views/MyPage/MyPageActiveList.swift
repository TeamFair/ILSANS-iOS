//
//  MyPageActiveList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageActiveList: View {
    
    @ObservedObject var vm: MypageViewModel = MypageViewModel(userNetwork: UserNetwork(),xpNetwork: XPNetwork(), questNetwork: ChallengeNetwork(), imageNetwork: ImageNetwork())
    
    @Binding var activeData: [XPContent]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("최근 활동 순")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                
                Spacer()
            }
            // Data List
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(activeData) { Data in
                        ListStruct(title: Data.title, detail: Data.createDate, point: Data.xpPoint)
                    }
                }
            }
            .refreshable {
                await vm.getxpLog(userId: "string", title: "string", page: 0, size: 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}