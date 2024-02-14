//
//  ApiInfo.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

struct ApiInfo {
    
    static func getRepo(username: String) -> ApiValue {
        .init(
            path: "/users/\(username)/repos",
            requestType: .get,
            header: .basicHeader
        )
    }
}

private extension ApiValue {
    init(
        path: String,
        requestType: ApiReqeustType,
        header: ApiHeaderType
    ) {
        self.init(
            path: path,
            requestType: requestType,
            header: header,
            apiUrl: .mainEnv
        )
    }
}
