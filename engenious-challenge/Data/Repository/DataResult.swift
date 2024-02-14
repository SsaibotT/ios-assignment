//
//  DataResult.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

class DataResultService {
    func entity<T: Codable>(ofType type: T.Type, from data: Data) -> T? {
        return try? JSONDecoder().decode(type, from: data)
    }

    func dataResult<T: Codable>(ofType type: T.Type, data: Data) -> Result<T, ApiError> {
        if let entity = entity(ofType: type, from: data) {
            return .success(entity)
        } else {
            return .failure(.noData)
        }
    }
}
