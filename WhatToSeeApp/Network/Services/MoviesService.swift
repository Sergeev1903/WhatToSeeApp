//
//  MoviesService.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation

protocol MoviesServiceable {
  func getUpcoming(
    completion: @escaping (Result<TMDBMovieResponse, RequestError>) -> Void)
  func getMovieDetail(
    id: Int,
    completion: @escaping (Result<TMDBMovieResult, RequestError>) -> Void)
}

struct MoviesService: HTTPClient, MoviesServiceable {
  
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
  
}

