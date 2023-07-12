//
//  NetworkService.swift
//  CinemaReview
//
//  Created by Артем Сергеев on 03.06.2023.
//

import Foundation

class NetworkService {
  
  static let shared = NetworkService()
  private init() {}
  
  func getData(
    from url: URL?,
    completion: @escaping (Result<Data, Error>) -> Void) {
      
      guard let url else { print("Invalid URL")
        return
      }
      
      let session = URLSession.shared.dataTask( with: url) { data, response, error in
        
        if let error = error {
          completion(.failure(error))
          return
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode)
        else {
          print("Invalid Response")
          return
        }
        
        guard let data = data
        else {
          completion(.failure(
            NSError(domain: "No data returned", code: 0, userInfo: nil)))
          return
        }
        
        completion(.success(data))
        
      }
      session.resume()
    }
}

