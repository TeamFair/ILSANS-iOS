//
//  MyPageActiveList.swift
//  ILSANG
//
//  Created by Kim Andrew on 7/18/24.
//

import SwiftUI

struct MyPageActiveList: View {
    
    @Binding var activeData: [XPContent]
    
    var body: some View {
        
        
        if activeData.isEmpty {
            VStack {
                Text("Coming Soon!")
                    .font(.system(size: 17))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                    .multilineTextAlignment(.center)
                    .refreshable {
                        // 데이터 리프레시
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            VStack(alignment: .leading) {
                Text("최근 활동 순")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(.gray400)
                
                // Data List
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(activeData) { Data in
                            ListStruct(title: Data.title, detail: Data.createDate, point: Data.xpPoint)
                        }
                    }
                }
                .refreshable {
                    // 데이터 리프레시
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
