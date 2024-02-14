//
//  ApiClient.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation
import Combine

protocol ApiClientProtocol {
    func procedure<T: Codable>(api: ApiValue) -> AnyPublisher<T, ApiError>
    func procedure(api: ApiValue, completion: @escaping ((Result<Data?, ApiError>) -> Void))
}

struct ApiClient: ApiClientProtocol {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func procedure<T: Codable>(
        api: ApiValue
    ) -> AnyPublisher<T, ApiError> {
        guard let request = makeRequest(
            urlString: api.path,
            headers: api.headers,
            requestType: .get
        ) else { return Fail(outputType: T.self, failure: ApiError.badRequest).eraseToAnyPublisher() }
        
        switch api.type {
        case .get:
            return get(request: request)
        default:
            print("Implement other cases")
            return Fail(outputType: T.self, failure: ApiError.undefined).eraseToAnyPublisher()
        }
    }
    
    private func get<T: Codable>(request: URLRequest) -> AnyPublisher<T, ApiError> {
        return urlSession
            .dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { data, response in
                
                guard let response = response as? HTTPURLResponse else {
                    throw ApiError.undefined
                }
                
                let code = response.statusCode
                
                if !(200...299).contains(code) {
                    throw ApiError.badRequest
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                return handleError(error)
            }
            .eraseToAnyPublisher()
    }
    
    private func makeRequest(urlString: String, headers: ApiHeaders, requestType: ApiReqeustType) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.allHTTPHeaderFields = headers
        
        return request
    }
    
    private func handleError(_ error: Error) -> ApiError {
        switch error {
        case is Swift.DecodingError:
            return .noData
        case let error as ApiError:
            return error
        default:
            return .undefined
        }
    }
}

// Non combine get
extension ApiClient {
    
    func procedure(
        api: ApiValue,
        completion: @escaping ((Result<Data?, ApiError>) -> Void)
    ) {
        guard let request = makeRequest(
            urlString: api.path,
            headers: api.headers,
            requestType: .get
        ) else { 
            completion(.failure(ApiError.badRequest))
            return
        }
        
        switch api.type {
        case .get:
            get(request: request, completion: completion)
        default:
            print("Implement other cases")
            completion(.failure(ApiError.undefined))
        }
    }
    
    private func get(request: URLRequest, completion: @escaping ((Result<Data?, ApiError>) -> Void)) {
        urlSession.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(ApiError.undefined))
                return
            }
            
            let code = response.statusCode
            
            if !(200...299).contains(code) {
                completion(.failure(ApiError.badRequest))
            }
            
            completion(.success(data))
        }.resume()
    }
}
