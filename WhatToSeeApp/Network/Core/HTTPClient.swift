//
//  HTTPClient.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation

protocol HTTPClient {
  func sendRequest<T: Codable>(
    endpoint: Endpoint, responseModel: T.Type,
    completion: @escaping (Result<T, RequestError>) -> Void)
}

extension HTTPClient {
  func sendRequest<T: Codable>(
    endpoint: Endpoint, responseModel: T.Type,
    completion: @escaping (Result<T, RequestError>) -> Void) {
      
      var urlComponents = URLComponents()
      urlComponents.scheme = endpoint.scheme
      urlComponents.host = endpoint.host
      urlComponents.path = endpoint.path
      
      guard let url = urlComponents.url else {
        completion(.failure(.invalidURL))
        return
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = endpoint.method.rawValue
      request.allHTTPHeaderFields = endpoint.header
      
      if let body = endpoint.body {
          request.httpBody = try? JSONSerialization.data(
            withJSONObject: body, options: [])
      }
      
      let task = URLSession.shared.dataTask(
        with: request) { (data, response, error) in
          if error != nil {
            completion(.failure(.unknown))
            return
          }
          
          guard let data = data,
                let response = response as? HTTPURLResponse else {
            completion(.failure(.noResponse))
            return
          }
          
          switch response.statusCode {
          case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let decodedResponse = try? decoder.decode(
              responseModel, from: data) else {
              completion(.failure(.decode))
              return
            }
            completion(.success(decodedResponse))
          case 401:
            completion(.failure(.unauthorized))
          default:
            completion(.failure(.unexpectedStatusCode))
          }
        }
      task.resume()
    }
}

