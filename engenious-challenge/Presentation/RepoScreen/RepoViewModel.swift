//
//  RepoViewModel.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation
import Combine

final class RepoViewModel {
    private let repository: RepoRepositoryProtocol
    private var cancelables = Set<AnyCancellable>()
    let username: String
    
    private(set) var repos: CurrentValueSubject<[Repo], Never> = CurrentValueSubject([])
    private(set) var errorMessage: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    init(repository: RepoRepositoryProtocol = RepoRepository(), username: String) {
        self.repository = repository
        self.username = username
    }
    
    func getRepo() {
        repository.getRepo(username: username)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] error in
                switch error {
                case .finished:
                    break
                case .failure(let failure):
                    // In here we need to switch through failure
                    self?.errorMessage.value = "Error"
                }
            }, receiveValue: { [weak self] repos in
                self?.repos.send(repos)
            })
            .store(in: &cancelables)
    }
    
    // Non combine request
    func getRepo(completion: @escaping (Result<[Repo], ApiError>) -> Void) {
        repository.getRepo(username: username, completion: completion)
    }
}
