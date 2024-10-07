//
//  RankingView.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import SwiftUI

struct RankingView: View {
    
    @StateObject var vm = RankingViewModel(userNetwork: UserNetwork())
    
    var body: some View {
        VStack{
            HStack {
                Text("랭킹")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(.gray500)
            }
            
            //subHeaderView
            
            switch vm.viewStatus {
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
                
            case .loaded:
                rankingListView
                
            case .error:
                VStack{}
            }
            
        }
    }
}

extension RankingView {
//    private var subHeaderView: some View {
//        HStack(spacing: 0) {
//            ForEach(XpStat.allCases, id: \.headerText) { xpStat in
//                Button {
//                    withAnimation(.easeInOut) {
//                        vm.selectedXpStat = xpStat
//                    }
//                } label: {
//                    Text(xpStat.headerText)
//                        .foregroundColor(xpStat == vm.selectedXpStat ? .gray500 : .gray300)
//                        .font(.system(size: 16, weight: xpStat == vm.selectedXpStat ? .semibold : .medium))
//                        .frame(height: 30)
//                }
//                .padding(.horizontal, 6)
//                .overlay(alignment: .bottom) {
//                    if xpStat == vm.selectedXpStat {
//                        Rectangle()
//                            .frame(height: 3)
//                            .foregroundStyle(.primaryPurple)
//                            .matchedGeometryEffect(id: "XpStat", in: namespace)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//        }
//        .overlay(alignment: .bottom) {
//            Rectangle()
//                .frame(height: 1)
//                .foregroundStyle(.gray100)
//        }
//    }
    
    private var rankingListView: some View {
        ScrollView {
            Text("Testing")
        }
    }
}

#Preview {
    RankingView()
}
