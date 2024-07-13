//
//  String++.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/7/24.
//

import Foundation

extension String {
    /// 서버에서 보내주는 시간을 "12월 31일" 형식으로 날짜 포맷 변환.
    /// 현재와 년도가 다를 경우 "2024년 12월 31일"로 변환.
    ///
    /// 서버 응답 예시들: 3125-01-02T00:00:00, 2024-07-04T00:31:57.313048
    func timeAgoSinceDate() -> String {
        let date = self.split(separator: ".")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: String(date[0])) else { return "" }
        // 현재 년도 구하기
        let currentYear = Calendar.current.component(.year, from: Date())
        let dateYear = Calendar.current.component(.year, from: date)
        
        // 날짜 포맷 설정
        var dateFormat = "M월 d일"
        if currentYear != dateYear {
            dateFormat = "yyyy년 " + dateFormat
        }
        
        // 설정한 포맷으로 변환
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    /// 서버에서 보내주는 값을 1,000 형태로 포맷 변경
    /// 천의 자리 배수에 ","을 추가합니다. "1,000,000" 형식
    func formatNumberInText() -> String {
        guard let num = Int(self) else { return self }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: num)) ?? ""
    }
}
