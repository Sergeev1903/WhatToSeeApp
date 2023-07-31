//
//  ShowAllViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import Foundation


protocol ShowAllViewModelProtocol: AnyObject {
  var currentPage: Int { get set }
  var totalPages: Int { get set }
  var mediaItems: [TMDBMovieResult] { get }
  var category: String { get }
  init(mediaItems: [TMDBMovieResult], category: MovieCategory)
  func loadMoreItems(completion: () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
  
}


class ShowAllViewModel: ShowAllViewModelProtocol {
  
  // MARK: - Properties
  let service: MoviesService
  
  var mediaItems: [TMDBMovieResult]
  let category: String
  
  var currentPage: Int = 1
  var totalPages: Int = 1
  
  
  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult], category: MovieCategory) {
    self.mediaItems = mediaItems
    self.category = category.rawValue
    self.service = MoviesService()
  }
  
  
  func loadMoreItems(completion: () -> Void) {
    service.getMedia(endpoint: MoviesEndpoint.nowPlaying(page: currentPage), responseModel: TMDBMovieResponse.self) { [weak self] result in
      
      guard let strongSelf = self else { return }
      
      switch result {
      case .success(let response):
        strongSelf.totalPages = response.totalPages
        strongSelf.mediaItems.append(contentsOf: response.results)
      case .failure(let error):
        print(error.customMessage)
      }
    }
    
  }
  
  
  
  // MARK: - Methods
  func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
    let media = mediaItems[indexPath.item]
    return CategoryCellItemViewModel(media: media)
  }
  
  func didSelectItemAt(
   indexPath: IndexPath) -> DetailViewModelProtocol {
    let media = mediaItems[indexPath.item]
    return DetailViewModel(media: media)
   }
  
}
