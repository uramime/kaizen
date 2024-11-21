//
//  NetworkManager.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 21.11.24..
//

import Foundation

enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
}

class NetworkService {
    
    private let sportsURL = "https://ios-kaizen.github.io/MockSports/sports.json"
    
    func fetchSports(completion: @escaping (Result<[Sport], NetworkError>) -> Void) {
        guard let url = URL(string: sportsURL) else {
            completion(.failure(.badURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(.requestFailed))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let sports = try decoder.decode([Sport].self, from: data)
                completion(.success(sports))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        task.resume()
    }
}

