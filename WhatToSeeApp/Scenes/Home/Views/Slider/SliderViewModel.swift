//
//  SliderViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  func getMedia(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> SliderItemViewModelProtocol
}


class SliderViewModel: SliderViewModelProtocol {

  // MARK: - Properties
  private let service: MoviesServiceable
  var mediaItems: [TMDBMovieResult] = [] {
    didSet {
      mediaItems.count
    }
  }

  // MARK: - Init
  init(service: MoviesServiceable) {
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
  
  func cellForItemAt(indexPath: IndexPath) -> SliderItemViewModelProtocol {
      let media = mediaItems[indexPath.item]
     return SliderItemViewModel(media: media)
    }
  
}
