//
//  RepoRepository.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation
import Combine

struct RepoRepository {
    var apiClient: ApiClientProtocol!
    
    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    func getRepo(username: String) -> AnyPublisher<[Repo], ApiError> {
        return apiClient.procedure(api: ApiInfo.getRepo(username: username))
    }
}
