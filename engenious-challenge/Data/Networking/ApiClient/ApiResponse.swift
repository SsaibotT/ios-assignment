//
//  ApiResponse.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

enum ApiError: Error {
    case error(Error)
    case badRequest
    case noData
    case undefined
    case limitedResponse
}
