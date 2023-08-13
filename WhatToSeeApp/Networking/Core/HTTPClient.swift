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
      urlComponents.queryItems = endpoint.queryItems
      
      guard let url = urlComponents.url else {
        return completion(.failure(.invalidURL))
      }
      
      var request = URLRequest(url: url)
      request.httpMethod = endpoint.method.rawValue
      request.allHTTPHeaderFields = endpoint.header
      
      if endpoint.method == .post,
         let body = endpoint.body {
        do {
          request.httpBody = try JSONSerialization.data(
            withJSONObject: body, options: [])
        } catch {
          return completion(.failure(.encode))
        }
      }
      
      
      let task = URLSession.shared.dataTask(
        with: request) { (data, response, error) in
          if error != nil {
            return completion(.failure(.unknown))
          }
          
          guard let data = data,
                let response = response as? HTTPURLResponse else {
            return completion(.failure(.noResponse))
          }
          
          switch response.statusCode {
          case 200...299:
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
              let decodedResponse = try decoder.decode(
                responseModel, from: data)
              completion(.success(decodedResponse))
            } catch {
              completion(.failure(.decode))
            }
          case 401:
            completion(.failure(.unauthorized))
          default:
            print(response.statusCode)
            completion(.failure(.unexpectedStatusCode(code: response.statusCode)))
          }
        }
      task.resume()
    }
  
}


