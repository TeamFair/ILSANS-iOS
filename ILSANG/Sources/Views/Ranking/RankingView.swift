//
//  RankingView.swift
//  ILSANG
//
//  Created by Kim Andrew on 10/7/24.
//

import SwiftUI

struct RankingView: View {
    
    @StateObject var vm = RankingViewModel(userNetwork: UserNetwork())
    @Namespace private var namespace
    
    var body: some View {
        VStack (spacing: 0){
            //HeaderView
            HStack {
                Text("랭킹")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(.gray500)
                
                Spacer()
            }
            .frame(height: 50)
            .padding(.horizontal, 20)
            
            subHeaderView
            
            switch vm.viewStatus {
            case .loading:
                ProgressView().frame(maxHeight: .infinity)
                
            case .loaded:
                rankingListView
                
            case .error:
                networkErrorView
            }
            
        }
        .background(Color.background)
        .task {
            await vm.loadUserRank(xpStat: vm.selectedXpStat.parameterText)
        }
        .onChange(of: vm.selectedXpStat) { stat in
            Task {
                await vm.loadUserRank(xpStat: stat.parameterText)
            }
        }
    }
}

extension RankingView {
    private var subHeaderView: some View {
        HStack(spacing: 0) {
            ForEach(XpStat.allCases, id: \.headerText) { xpStat in
                Button {
                    withAnimation(.easeInOut) {
                        vm.selectedXpStat = xpStat
                    }
                } label: {
                    Text(xpStat.headerText)
                        .foregroundColor(xpStat == vm.selectedXpStat ? .gray500 : .gray300)
                        .font(.system(size: 16, weight: xpStat == vm.selectedXpStat ? .semibold : .medium))
                        .frame(height: 30)
                }
                .padding(.horizontal, 6)
                .overlay(alignment: .bottom) {
                    if xpStat == vm.selectedXpStat {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(.primaryPurple)
                            .matchedGeometryEffect(id: "XpStat", in: namespace)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.gray100)
        }
    }
    
    private var networkErrorView: some View {
        ErrorView(
            systemImageName: "wifi.exclamationmark",
            title: "네트워크 연결 상태를 확인해주세요",
            subTitle: "네트워크 연결 상태가 좋지 않아\n퀘스트를 불러올 수 없어요 ",
            emoticon: "🥲"
        ) {
            Task { await vm.loadUserRank(xpStat: vm.selectedXpStat.parameterText) }
        }
    }
    
    private var rankingListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Array(vm.userRank.enumerated()), id: \.element.xpPoint) { idx, rank in
                    RankingItemView(level: idx + 1, rank: rank)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 72)
        }
    }
}

#Preview {
    RankingView()
}
