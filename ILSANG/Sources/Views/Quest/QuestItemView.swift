//
//  QuestItemView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/22/24.
//

import SwiftUI

/// 공통 데이터 구조
struct QuestCommonModel {
    let title: String
    let writer: String
    let rewardDic: [XpStat: Int]
    let writerImage: UIImage?
    let image: UIImage?
    let type: String
    let target: String
    let tagTitle: String?
    let action: (() -> Void)?
}

/// 퀘스트 스타일 프로토콜
protocol QuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { get }
    var tagOffset: (x: CGFloat, y: CGFloat) { get }
    var imageSize: CGSize { get }
    var trailingPadding: CGFloat { get }
    var backgroundColor: Color { get }
    var isDisabled: Bool { get }
    
    associatedtype ItemView: View
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> ItemView
}

/// 퀘스트 스타일 프로토콜: 기본값 설정
extension QuestStyleProtocol {
    var tagOffset: (x: CGFloat, y: CGFloat) { (0, 0) }
    var imageSize: CGSize { CGSize(width: 60, height: 60) }
    var trailingPadding: CGFloat { 0 }
    var backgroundColor: Color { .white }
    var isDisabled: Bool { false }
}

protocol DefaultQuestStyleProtocol: QuestStyleProtocol {
    associatedtype TrailingView: View
    associatedtype OverlayView: View
   
    @ViewBuilder
    func trailingView()  -> TrailingView
   
    @ViewBuilder
    func overlayView()  -> OverlayView
}

struct UncompletedStyle: DefaultQuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { .xp }
    var tagOffset: (x: CGFloat, y: CGFloat) { (48, 5) }
    var trailingPadding: CGFloat { 20 }
        
    func trailingView() -> some View {
        IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
    }
    
    func overlayView() -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: UncompletedStyle())
    }
}

struct CompletedStyle: DefaultQuestStyleProtocol {
    static let separatorOffset: CGFloat = 72.0

    var tagStyle: TagView.TagStyle? { .xp }
    var tagOffset: (x: CGFloat, y: CGFloat) { (48, 5) }
    var isDisabled: Bool { true }
    
    @ViewBuilder
    func trailingView() -> some View {
        VStack(spacing: 7) {
            IconView(iconWidth: 13, size: .small, icon: .check, color: .green)
            Text("적립완료")
                .font(.system(size: 12, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.green)
        }
        .frame(width: CompletedStyle.separatorOffset)
    }

    @ViewBuilder
    func overlayView() -> some View {
        VLine()
            .stroke(style: StrokeStyle(lineWidth: 0.5, dash: [3.3]))
            .frame(width: 0.5)
            .foregroundStyle(.gray200)
            .offset(x: -CompletedStyle.separatorOffset)
            .padding(.vertical, 12)
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: CompletedStyle())
    }
}

struct RepeatStyle: DefaultQuestStyleProtocol {
    let repeatType: RepeatType

    var tagStyle: TagView.TagStyle? { .repeat(repeatType) }
    var tagOffset: (x: CGFloat, y: CGFloat) { (54, 3) }
    var trailingPadding: CGFloat { 20 }
    
    func trailingView() -> some View {
        IconView(iconWidth: 6, size: .small, icon: .arrowRight, color: .gray)
    }
    
    func overlayView() -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        DefaultQuestView(quest: quest, style: RepeatStyle(repeatType: repeatType))
    }
}


struct RecommendStyle: QuestStyleProtocol {
    var tagStyle: TagView.TagStyle? { nil }
    var tagOffset: (x: CGFloat, y: CGFloat) { (16, 16) }
    var imageSize: CGSize { CGSize(width: 64, height: 64)}
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        RecommendQuestView(quest: quest, style: RecommendStyle())
    }
}

struct PopularStyle: QuestStyleProtocol {
    let repeatType: RepeatType
    
    var tagStyle: TagView.TagStyle? { .repeat(repeatType) }
    var tagOffset: (x: CGFloat, y: CGFloat) { (16, 16) }
    var imageSize: CGSize { CGSize(width: (UIScreen.main.bounds.width - 40 - 2) / 2, height: 137)}
    
    @ViewBuilder
    func viewForQuest(quest: QuestCommonModel) -> some View {
        PopularQuestView(quest: quest, style: PopularStyle(repeatType: repeatType))
    }
}


// 공통 퀘스트 아이템 뷰
struct QuestItemView<Style: QuestStyleProtocol>: View {
    let quest: QuestCommonModel
    let style: Style
    
    fileprivate struct Constants {
        let separatorOffset = 72.0
    }

    init(quest: QuestViewModelItem, style: Style, tagTitle: String? = nil, action: @escaping () -> Void) {
        self.quest = QuestCommonModel(
            title: quest.missionTitle,
            writer: quest.writer,
            rewardDic: quest.rewardDic, 
            writerImage: quest.image,
            image: quest.image, 
            type: quest.type,
            target: quest.target,
            tagTitle: tagTitle,
            action: action
        )
        self.style = style
    }
    
    var body: some View {
        style.viewForQuest(quest: quest)
    }
}

// 기본 스타일
struct DefaultQuestView<Style: DefaultQuestStyleProtocol>: View {
    let quest: QuestCommonModel
    let style: Style
    
    var body: some View {
        Button(action: { quest.action?() }) {
            HStack(spacing: 0) {
                // 이미지 및 태그 뷰
                QuestImageWithTagView(
                    image: quest.writerImage,
                    tagTitle: quest.tagTitle ?? "",
                    tagStyle: style.tagStyle ?? .xp,
                    tagOffset: style.tagOffset, 
                    imageSize: style.imageSize
                )
                .padding(.trailing, 20)
                
                // 텍스트 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(quest.title.forceCharWrapping)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Text(quest.writer)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.gray400)
                        .padding(.bottom, 4)
                    StatGridView(rewardDic: quest.rewardDic)
                }
                Spacer(minLength: 0)
                style.trailingView()
            }
            .padding(.vertical, 20)
            .padding(.leading, 20)
            .padding(.trailing, style.trailingPadding)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .overlay(alignment: .trailing) {
                style.overlayView()
            }
            .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 20)
        }
        .disabled(style.isDisabled)
    }
}


// Popular 스타일
struct PopularQuestView<Style: QuestStyleProtocol>: View {
    let quest: QuestCommonModel
    let style: Style
    
    var body: some View {
        Button(action: { quest.action?() }) {
            VStack(alignment: .leading, spacing: 0) {
                Image(uiImage: quest.image ?? .logo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: style.imageSize.width, height:  style.imageSize.height)
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        if let tagTitle = RepeatType(rawValue: quest.target.lowercased())?.description {
                            TagView(title: tagTitle, tagStyle: style.tagStyle ?? .xp)
                                .offset(x: -style.tagOffset.x, y: style.tagOffset.y)
                        }
                    }
                    .padding(.horizontal, -16)
                    .padding(.bottom, 9)
                Text(quest.title.forceCharWrapping)
                    .font(.system(size: 15, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .lineSpacing(4)
                    .foregroundColor(.black)
                    .padding(.bottom, 4)
                Text(quest.writer)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(.gray400)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .frame(width:style.imageSize.width, height: 220, alignment: .top)
            .background(
                Rectangle()
                    .foregroundStyle(style.backgroundColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// Recommend 스타일
struct RecommendQuestView<Style: QuestStyleProtocol>: View {
    let quest: QuestCommonModel
    let style: Style

    var body: some View {
        Button(action: { quest.action?() }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(quest.title.forceCharWrapping)
                    .font(.system(size: 13, weight: .bold))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .lineSpacing(4)
                    .kerning(-0.3)
                    .foregroundColor(.black)
                    .padding(.bottom, 6)
                Text(quest.writer)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(.gray400)
                    .kerning(-0.3)
                Spacer(minLength: 0)
                Image(uiImage: quest.writerImage ?? .logo)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 64, height: 64)
                    .background(Color.badgeBlue)
                    .clipShape(Circle())
            }
            .padding(16)
            .padding(.top, 4)
            .frame(width: 152, height: 172, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12)
                .fill(style.backgroundColor)
            )
        }
    }
}
