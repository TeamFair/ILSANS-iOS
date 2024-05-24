//
//  MyPageView.swift
//  ILSANG
//
//  Created by Lee Jinhee on 5/20/24.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        
        VStack {
            
            //프로필 제목
            HStack {
                Text("내 프로필")
                Spacer()
                Image(systemName: "gearshape")
            }
            
            //개인 프로필
            MyPageProfile()
            
            //Segmenet
            MyPageSegmenet()
            
            //퀘스트 List
            MyPageList()
        }
        //MARK: 추후 삭제 
        .background(Color.gray100)
    }
}

#Preview {
    MyPageView()
}
