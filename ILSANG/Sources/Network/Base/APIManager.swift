//
//  APIManager.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/16/24.
//

import Foundation

final class APIManager {
    static let baseURL = "http://43.202.229.190"
    
    #if DEBUG
    static let port = "9090"
    #else
    static let port = "9091"
    #endif
    
    ///개발용 토큰
    static let authDevelopToken = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJkNTg5MjQ3MC01ZDY5LTQ5NDctOGE4Ny1mMDY0OWRlNmVkOWMiLCJ1c2VyVHlwZSI6IkNVU1RPTUVSIn0.lsxRIl6u0WF0dUdHulTTS3HrPyo8D_2w5Bva3-tnAw8"
    
    static func makeURL(_ target: APITarget) -> String {
        baseURL + ":" + port + "/api/" + target.type + "/" + target.path
    }
}
