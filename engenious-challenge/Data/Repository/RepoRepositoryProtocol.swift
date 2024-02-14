//
//  RepoRepositoryProtocol.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation
import Combine

protocol RepoRepositoryProtocol {
    func getRepo(username: String) -> AnyPublisher<[Repo], ApiError>
    func getRepo(username: String, completion: @escaping (Result<[Repo], ApiError>) -> Void)
}
