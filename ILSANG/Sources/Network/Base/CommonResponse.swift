//
//  CommonResponse.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/22/24.
//

struct Response<T: Decodable>: Decodable {
    let data: T
    let errorStatus: String?
    let errMessage: String?
    let status, message: String
    
    init(data: T, errorStatus: String?, errMessage: String?, status: String, message: String) {
        self.data = data
        self.errorStatus = errorStatus
        self.errMessage = errMessage
        self.status = status
        self.message = message
    }
}

struct ResponseWithPage<T: Decodable>: Decodable {
    let size: Int
    let data: T
    let total: Int
    let page: Int
    let status: String
    let message: String
}

struct ResponseWithoutData: Decodable {
    let data: [String: String]?
    let errorStatus: String?
    let errMessage: String?
    let status: String
    let message: String
    
    init(data: [String: String], errorStatus: String?, errMessage: String?, status: String, message: String) {
        self.data = data
        self.errorStatus = errorStatus
        self.errMessage = errMessage
        self.status = status
        self.message = message
    }
}
