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
}
