//
//  NetworkService.swift
//  TravelTaipei
//
//  Created by user on 2024/12/30.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    
    func request<T: Codable>(api: TravelTaipeiApi, model: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        let session = URLSession.shared
        
        let task = session.dataTask(with: api.urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.unknownError))
                return
            }
            
            do {
                let decodedModel = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedModel))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case networkError(Error)
    case serverError(Int)
    case decodingError(Error)
    case unknownError
}
