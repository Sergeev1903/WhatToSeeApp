//
//  SliderViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  init(service: MoviesServiceable)
  func getMedia(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol
}


class SliderViewModel: SliderViewModelProtocol {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  var mediaItems: [TMDBMovieResult] = []
  
  
  // MARK: - Init
  required init(service: MoviesServiceable) {
    self.service = service
  }
  
  // MARK: - Networking
  func getMedia(completion: @escaping () -> Void) {
    service.getUpcoming {[weak self] result in
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
  
  
  // MARK: - Configure slider collection
  func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return SliderCellViewModel(media: media)
    }
  
}
