//
//  MoviesService.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation

protocol MoviesServiceable {
    func getMedia<T: Codable>(
      endpoint: Endpoint, responseModel: T.Type,
      completion: @escaping (Result<T, RequestError>) -> Void)
  
  func getMovieDetail(
    id: Int,
    completion: @escaping (Result<TMDBMovieDetail, RequestError>) -> Void)
  
  func getMovieTrailers(
    id: Int,
    completion: @escaping (Result<Videos, RequestError>) -> Void)
  
  func loadData(url: URL) -> Data?
}

struct MoviesService: HTTPClient, MoviesServiceable {
  
  func getMedia<T>(endpoint: Endpoint,
                   responseModel: T.Type,
                   completion: @escaping (Result<T, RequestError>) -> Void)
  where T : Decodable, T : Encodable {
    
    DispatchQueue.global(qos: .utility).async {
      sendRequest(endpoint: endpoint,
                  responseModel: responseModel.self) { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }

  
  // MARK: - Movie detail
  func getMovieDetail(
    id: Int,
    completion: @escaping (Result<TMDBMovieDetail, RequestError>) -> Void) {
      sendRequest(
        endpoint: MoviesEndpoint.movieDetail(id: id),
        responseModel: TMDBMovieDetail.self) { result in
          DispatchQueue.main.async {
            completion(result)
          }
        }
    }
  
  
  func getMovieTrailers(
    id: Int,
    completion: @escaping (Result<Videos, RequestError>) -> Void) {
      sendRequest(
        endpoint: MoviesEndpoint.movieTrailers(id: id),
        responseModel: Videos.self) { result in
          DispatchQueue.main.async {
            completion(result)
          }
        }
    }
  
  
  // MARK: - Load data GCD: semaphores
  func loadData(url: URL) -> Data? {
    return fetchData(from: url)
  }
  
}

