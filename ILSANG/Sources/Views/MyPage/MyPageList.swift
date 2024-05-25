//
//  MyPageList.swift
//  ILSANG
//
//  Created by Kim Andrew on 5/22/24.
//

import SwiftUI
//MARK: 색상 폰트 변경 요청
struct MyPageList: View {
    
    @State var isData: Bool = true
    @State var testData = [["Title1", "Detail1", 50],["Title2", "Detail2", 100]]
    
    var body: some View {
        
        if isData {
            VStack (alignment: .leading){
                Text("최근 활동 순")
                    .foregroundColor(Color.gray300)
                //Data List
                ScrollView {
                    ForEach(testData.indices, id: \.self) { index in
                        ListStruct(title: testData[index][0] as! String, detail: testData[index][1] as! String, point: testData[index][2] as! Int)
                    }
                }
                .refreshable {
                    //데이터 리프레시
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            VStack {
                Text("Coming Soon!")
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.gray)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct ListStruct: View {
    
    let title: String
    let detail: String
    let point: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Text(detail)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("+\(point)XP")
                .foregroundColor(Color.blue)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.white)
        )
    }
}

#Preview {
    MyPageList()
}
