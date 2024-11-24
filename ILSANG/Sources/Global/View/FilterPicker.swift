//
//  FilterPicker.swift
//  ILSANG
//
//  Created by Lee Jinhee on 11/6/24.
//

import SwiftUI

struct PickerView<SelectionValue>: View where SelectionValue: Hashable & CustomStringConvertible & CaseIterable {
    @State var status: PickerStatus = .close
    @Binding var selection: SelectionValue
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 0) {
                Text("\(selection.description)")
                    .font(.system(size: 15, weight: .regular))
                Spacer(minLength: 0)
                Image(systemName: status == .open ? "chevron.down" : "chevron.up")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12)
                    .frame(width: 19, height: 19)
            }
            .foregroundStyle(.gray500)
            .padding(.horizontal, 12)
            .frame(width: 150, height: 40)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 8)
            )
            .onTapGesture {
                self.status.toggle()
            }
            .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
            
            if status == .open {
                VStack(spacing: 0) {
                    ForEach(Array(SelectionValue.allCases).filter { $0 != selection }, id: \.self) { value in
                        Button(action: {
                            self.selection = value
                            self.status.toggle()
                        }) {
                            Text(value.description)
                                .font(.system(size: 15, weight: .regular))
                                .foregroundStyle(.gray500)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .frame(height: 40)
                                .background(Color.white)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .frame(width: 150)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(color: .shadow7D.opacity(0.05), radius: 20, x: 0, y: 10)
                .padding(.top, 44)
                .zIndex(1)
            }
        }
    }
}

enum QuestFilter: String, Hashable, CustomStringConvertible, CaseIterable {
    case pointHighest = "포인트 높은 순"
    case pointLowest = "포인트 낮은 순"
    case popular = "인기순"
    
    var description: String {
        return self.rawValue
    }
}

enum PickerStatus {
    case open
    case close
    
    mutating func toggle() {
        self = self == .open ? .close : .open
    }
}


//#Preview {
//    PickerView<ExampleSelection>(status: .close, selection: .constant(.option1))
//}
