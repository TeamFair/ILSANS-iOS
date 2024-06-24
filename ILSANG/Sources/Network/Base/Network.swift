//
//  Network.swift
//  ILSANG
//
//  Created by Lee Jinhee on 6/12/24.
//

import Alamofire
import Foundation
import UIKit

final class Network {
    
    private static func buildURL(url: String, parameters: Parameters? = nil, page: Int? = nil, size: Int? = nil) -> URL? {
        var components = URLComponents(string: url)
        var queryItems = [URLQueryItem]()

        if let parameters = parameters {
            for (key, value) in parameters {
                queryItems.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }

        if let page = page {
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        }
        
        if let size = size {
            queryItems.append(URLQueryItem(name: "size", value: "\(size)"))
        }
        
        components?.queryItems = queryItems
        return components?.url
    }
    
    private static func buildHeaders(withToken: Bool) -> HTTPHeaders {
        var headers: HTTPHeaders = ["accept": "application/json", "Content-Type": "application/json"]
        if withToken {
            headers.add(.authorization(APIManager.authDevelopToken))
        }
        return headers
    }
    
    static func requestData<T: Decodable>(url: String, method: HTTPMethod, parameters: Parameters?, body: Data? = nil, withToken: Bool, page: Int? = nil, size: Int? = nil) async -> Result<T, Error> {
        guard let fullPath = buildURL(url: url, parameters: parameters, page: page, size: size) else {
            return .failure(NetworkError.invalidURL)
        }
        
        let headers = buildHeaders(withToken: withToken)
        
        let request: DataRequest
        if let body = body {
            var urlRequest = URLRequest(url: fullPath)
            urlRequest.method = method
            urlRequest.headers = headers
            urlRequest.httpBody = body
            request = AF.request(urlRequest)
        } else {
            request = AF.request(fullPath, method: method, encoding: parameters != nil ? URLEncoding.queryString : JSONEncoding.default, headers: headers)
        }
        
        let response = await request.validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
            .response
        
        switch response.result {
        case .success(let res):
            return .success(res)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    static func requestImage(url: String, withToken: Bool) async -> Result<UIImage, Error> {
        guard let fullPath = buildURL(url: url) else {
            return .failure(NetworkError.invalidURL)
        }
        
        let headers = buildHeaders(withToken: withToken)
        
        let request: DataRequest
        request = AF.request(fullPath, method: .get, headers: headers)
        
        let response = await request.validate(statusCode: 200..<300)
            .serializingData()
            .response
        
        switch response.result {
        case .success(let imageData):
            guard let image = UIImage(data: imageData) else {
                return .failure(NetworkError.invalidImageData)
            }
            return .success(image)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case invalidImageData
    }
}
