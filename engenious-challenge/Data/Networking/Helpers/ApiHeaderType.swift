//
//  ApiHeaderType.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

enum ApiHeaderType {
    case basicHeader
    
    var header: ApiHeaders {
        switch self {
        case .basicHeader:
            return ApiHeader.basicHeader
        }
    }
}
