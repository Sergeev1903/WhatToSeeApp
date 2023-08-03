//
//  ShowAllViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import Foundation


protocol ShowAllViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  var category: String { get }
  var currentPage: Int { get set }
  var totalPages: Int { get set }
  init(mediaItems: [TMDBMovieResult], category: MovieCategory)
  func loadMoreItems(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class ShowAllViewModel: ShowAllViewModelProtocol {
  
  // MARK: - Properties
  public var mediaItems: [TMDBMovieResult]
  public let category: String
  public var currentPage: Int = 1
  public var totalPages: Int = 1
  
  private let service: MoviesServiceable
  

  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult], category: MovieCategory) {
    self.mediaItems = mediaItems
    self.category = category.rawValue
    self.service = MoviesService()
  }
  
  
  // MARK: -
  public func loadMoreItems(completion: @escaping () -> Void) {
    // FIXME: -
    var categoryEndpoint = MoviesEndpoint.upcoming
    
    switch category {
    case MovieCategory.nowPlaying.rawValue:
      categoryEndpoint = MoviesEndpoint.nowPlaying(page: currentPage)
    case MovieCategory.popular.rawValue:
      categoryEndpoint = MoviesEndpoint.popular(page: currentPage)
    case MovieCategory.topRated.rawValue:
      categoryEndpoint = MoviesEndpoint.topRated(page: currentPage)
    case MovieCategory.trending.rawValue:
      categoryEndpoint = MoviesEndpoint.trending(page: currentPage)
    default:
      break
    }
    // FIXME: -
    service.getMedia(
      endpoint: categoryEndpoint,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.totalPages = response.totalPages
          strongSelf.mediaItems.append(contentsOf: response.results)
        case .failure(let error):
          print(error.customMessage)
        }
        completion()
      }
  }
  
  
  // MARK: -
  public func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  public func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return CategoryCellItemViewModel(media: media)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return DetailViewModel(media: media)
    }
  
}
