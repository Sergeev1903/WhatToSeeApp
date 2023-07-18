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
  
  func getUpcoming(
    completion: @escaping (Result<TMDBMovieResponse, RequestError>) -> Void)
  
  func getMovieDetail(
    id: Int,
    completion: @escaping (Result<TMDBMovieResult, RequestError>) -> Void)
  
  func loadData(url: URL) -> Data?
}

struct MoviesService: HTTPClient, MoviesServiceable {
  
  func getMedia<T>(endpoint: Endpoint,
                   responseModel: T.Type,
                   completion: @escaping (Result<T, RequestError>) -> Void)
  where T : Decodable, T : Encodable {
    DispatchQueue.global().async {
      sendRequest(endpoint: endpoint,
                  responseModel: responseModel.self) { result in
        DispatchQueue.main.async {
          completion(result)
        }
      }
    }
  }
  
  
  func getUpcoming(
    completion: @escaping (Result<TMDBMovieResponse, RequestError>) -> Void) {
      DispatchQueue.global().async {
        sendRequest(
          endpoint: MoviesEndpoint.upcoming,
          responseModel: TMDBMovieResponse.self) { result in
            DispatchQueue.main.async {
              completion(result)
            }
          }
      }
    }
  
  
  func getMovieDetail(
    id: Int,
    completion: @escaping (Result<TMDBMovieResult, RequestError>) -> Void) {
      sendRequest(endpoint: MoviesEndpoint.movieDetail(id: id),
                  responseModel: TMDBMovieResult.self) { result in
        completion(result)
      }
    }
  
  func loadData(url: URL) -> Data? {
    return fetchData(from: url)
  }
  
}

