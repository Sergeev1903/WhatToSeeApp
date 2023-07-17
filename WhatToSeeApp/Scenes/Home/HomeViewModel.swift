//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  func getMedia(completion: @escaping () -> Void)
}


class HomeViewModel: HomeViewModelProtocol {
  private let service: MoviesServiceable
  var mediaItems: [TMDBMovieResult] = []
  
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  func getMedia(completion: @escaping () -> Void) {
    service.getUpcoming {[weak self] result in
      guard let strongSelf = self else { return }
      switch result {
      case .success(let movieResponse):
        strongSelf.mediaItems = movieResponse.results
      case .failure(let error):
        print(error)
      }
      completion()
    }
  }
  
}
