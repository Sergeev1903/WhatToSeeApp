//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  func getMedia(completion: @escaping () -> Void)
}


class HomeViewModel: HomeViewModelProtocol {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  var mediaItems: [TMDBMovieResult] = []


  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods  
  func getMedia(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.nowPlaying,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let movieResponse):
        strongSelf.mediaItems = movieResponse.results
      case .failure(let error):
        print(error.customMessage)
      }
      completion()
    }
  }
    
}


