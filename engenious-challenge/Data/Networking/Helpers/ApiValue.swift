//
//  ApiValue.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

enum ApiReqeustType: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

struct ApiValue {
    let subPath: String
    let type: ApiReqeustType
    let headerType: ApiHeaderType
    var sendedValue: String?
    let apiUrl: BasicURL
    
    init(
        path: String,
        requestType: ApiReqeustType,
        header: ApiHeaderType,
        apiUrl: BasicURL
    ) {
        self.subPath = path
        self.type = requestType
        self.headerType = header
        self.apiUrl = apiUrl
    }

    var path: String {
        "\(apiUrl.basicURL)\(subPath)"
    }
    
    var headers: ApiHeaders {
        headerType.header
    }
}
