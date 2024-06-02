//
//  ApprovalViewModel.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/1/24.
//

import SwiftUI

class ApprovalViewModel: ObservableObject {
    @Published var itemList = ApprovalViewModelItem.mockData
    @Published var idx = 0
    @Published var isScrolling = false
    
    func tappedRecommendBtn(recommend: Bool) {
        // TODO: API 요청 - itemList[idx].questId, recommend
    }
    
    func handleDragChange(_ value: DragGesture.Value) {
        if value.translation.height < 0 && idx != itemList.last!.id {
            isScrolling = true
            
            itemList[idx].offset = value.translation.height
            
            /// 다음 이미지 y축 올리는 효과
            if idx + 1 != itemList.last!.id {
                itemList[idx + 1].offset = -12
            }
        }
    }
    
    func handleDragEnd(_ value: DragGesture.Value, _ viewHeight: CGFloat) {
        if value.translation.height < 0 {  /// 위로 스크롤
            if idx != itemList.last!.id {
                itemList[idx].offset = -viewHeight
                if idx + 1 != itemList.last!.id {
                    itemList[idx + 1].offset = 0
                }
                idx += 1
            } else {
                itemList[idx].offset = 0
            }
        } else {  /// 아래로 스크롤
            if idx > 0 {
                if value.translation.height > 0 {
                    itemList[idx - 1].offset = 0
                    idx -= 1
                } else {
                    itemList[idx - 1].offset = -viewHeight
                }
            }
        }
        isScrolling = false
    }
    
    func calculateOpacity(id: Int) -> CGFloat {
        switch abs(id - idx) {
        case 0:
            return isScrolling ? 0.5 : 1 /// 활성화된 아이템이 >> 화면 스크롤 중이면 0.5, 스크롤 중이 아니면 1
        case 1:
            return isScrolling ? 1 : 0.5  /// 다음에 보여질 아이템이 >> 화면 스크롤 중이면 1, 스크롤 중이 아니면 0.5
        case 2:
            return 0.2
        default:
            return 0
        }
    }
}

struct ApprovalViewModelItem: Identifiable {
    var id: Int
    var title: String
    var image: String
    var offset: CGFloat
    var nickname: String
    var time: String
    
    static var mockData = [
        ApprovalViewModelItem(id: 0,title: "바닐라라떼마시기", image: "img0", offset: 0, nickname: "일상1", time: "3시간 전"),
        ApprovalViewModelItem(id: 1,title: "바닐라라떼마시기", image: "img1", offset: 0, nickname: "일상2", time: "1시간 전"),
        ApprovalViewModelItem(id: 2,title: "바닐라라떼마시기", image: "img2", offset: 0, nickname: "일상3", time: "2시간 전"),
        ApprovalViewModelItem(id: 3,title: "바닐라라떼마시기", image: "img3", offset: 0, nickname: "일상4", time: "2시간 전"),
        ApprovalViewModelItem(id: 4,title: "바닐라라떼마시기", image: "img0", offset: 0, nickname: "일상5", time: "1시간 전"),
        ApprovalViewModelItem(id: 5,title: "바닐라라떼마시기", image: "img1", offset: 0, nickname: "일상6", time: "3시간 전"),
        ApprovalViewModelItem(id: 6,title: "바닐라라떼마시기", image: "img2", offset: 0, nickname: "일상7", time: "2시간 전"),
        ApprovalViewModelItem(id: 7,title: "바닐라라떼마시기", image: "img3", offset: 0, nickname: "일상8", time: "3시간 전")
    ]
}
