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
    static let authDevelopToken =  "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJjODc3NzlkNi01YTc4LTQ2OTUtOGYxMy1lMDMxZjk1NTVkOTYiLCJ1c2VyVHlwZSI6IkNVU1RPTUVSIn0.DKQYepBPsqstv6nmeQPOvPjwAHdbtnFlASqrhd20uh4"
    
    static func makeURL(_ target: APITarget) -> String {
        baseURL + ":" + port + "/api/" + target.type + "/" + target.path
    }
}
