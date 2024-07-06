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
    static let authDevelopToken =    "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOiJhMTFjNDQxMS0xOTU0LTRiMWEtYjg0Ny0zYWY4NjU5MTNiM2YiLCJ1c2VyVHlwZSI6IkNVU1RPTUVSIn0.tM8UzimEvBVOH3hC-Put8J3iVU-QAeXlteRmcFjFHus"
    
    static func makeURL(_ target: APITarget) -> String {
        baseURL + ":" + port + "/api/" + target.type + "/" + target.path
    }
}
