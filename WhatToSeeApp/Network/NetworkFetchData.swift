//
//  NetworkFetchData.swift
//  CinemaReview
//
//  Created by Артем Сергеев on 03.06.2023.
//

import Foundation

class NetworkFetchData {
  
  static let shared = NetworkFetchData()
  private init() {}
  
  func fetchData<T: Codable>(
    from url: URL?,
    completion: @escaping (T) -> Void) {
      
      NetworkService.shared.getData(from: url) { result in
        
        switch result {
        case .success(let data):
          
          do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedData = try decoder.decode(T.self, from: data)
            completion(decodedData)
          }
          catch (let jsonError) {
            print(jsonError.localizedDescription)
          }
          
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  
}

