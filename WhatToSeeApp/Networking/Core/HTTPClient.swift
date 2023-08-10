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
  func fetchData(from url: URL) -> Data?
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
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        do {
          request.httpBody = try encoder.encode(body)
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
  
  
  func fetchData(from url: URL) -> Data? {
    // Create a semaphore to wait for the completion of the URLSessionDataTask
    let semaphore = DispatchSemaphore(value: 0)
    
    var data: Data?
    
    // Create a URLSessionDataTask to load the data from the URL
    let task = URLSession.shared.dataTask(with: url) { responseData, response, error in
      if let error = error {
        print("Error loading data: \(error.localizedDescription)")
      } else if let responseData = responseData {
        data = responseData
      }
      
      // Signal the semaphore to indicate that the task is complete
      semaphore.signal()
    }
    
    // Start the task
    task.resume()
    
    // Wait for the task to complete before returning the data
    _ = semaphore.wait(timeout: .distantFuture)
    return data
  }
  
}


