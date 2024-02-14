//
//  RepoRepository.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation
import Combine

class RepoRepository: DataResultService, RepoRepositoryProtocol {
    var apiClient: ApiClientProtocol
    
    init(apiClient: ApiClientProtocol = ApiClient()) {
        self.apiClient = apiClient
    }
    
    func getRepo(username: String) -> AnyPublisher<[Repo], ApiError> {
        return apiClient.procedure(api: ApiInfo.getRepo(username: username))
    }
    
    func getRepo(username: String, completion: @escaping (Result<[Repo], ApiError>) -> Void) {
        apiClient.procedure(api: ApiInfo.getRepo(username: username)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                
                if case .success(let repo) = self?.dataResult(ofType: [Repo].self, data: data) {
                    completion(.success(repo))
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
}
