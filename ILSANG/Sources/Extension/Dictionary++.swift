//
//  Dictionary++.swift
//  ILSANG
//
//  Created by Lee Jinhee on 7/7/24.
//

import Foundation

extension Dictionary {
    
    /// Dictionary를 JSON 데이터로 변환하는 함수
    func convertToJsonData() -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])
            return jsonData
        } catch {
            print("JSON Convert Error: \(error.localizedDescription)")
            return nil
        }
    }

}
