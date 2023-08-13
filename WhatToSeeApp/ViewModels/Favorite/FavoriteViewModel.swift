//
//  FavoriteViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.08.2023.
//

import Foundation


protocol FavoriteViewModelProtocol: AnyObject {
  func getFavoriteMovies(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class FavoriteViewModel: FavoriteViewModelProtocol {
  
  // MARK: - Properties
  private var mediaItems: [TMDBMovieResult] = []
  private let service: MoviesServiceable
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods
  public func getFavoriteMovies(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.favoriteMovies(page: 1),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.mediaItems = response.results
        case .failure(let error):
          print(error.message)
        }
        completion()
      }
  }
  
  public func numberOfItemsInSection() -> Int {
    mediaItems.count
  }
  
  public func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return CategoryCellItemViewModel(mediaItem: mediaItem)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return DetailViewModel(mediaItem: mediaItem)
    }
  
}
