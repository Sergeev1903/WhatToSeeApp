//
//  ShowAllViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import Foundation


protocol ShowAllViewModelProtocol: AnyObject {
  var category: String { get }
  var currentPage: Int { get set }
  var totalPages: Int { get set }
  func loadMoreItems(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class ShowAllViewModel: ShowAllViewModelProtocol {
  
  // MARK: - Properties
  public let category: String
  public var currentPage: Int = 1
  public var totalPages: Int = 1
  
  private var mediaItems: [TMDBMovieResult]
  private let service: MoviesServiceable
  
  private var categoryEndpoint: MovieEndpoint {
    var endpoint: MovieEndpoint = .upcoming
    
    switch category {
    case MovieCategory.nowPlaying.rawValue:
      endpoint = MovieEndpoint.nowPlaying(page: currentPage)
    case MovieCategory.popular.rawValue:
      endpoint =  MovieEndpoint.popular(page: currentPage)
    case MovieCategory.topRated.rawValue:
      endpoint = MovieEndpoint.topRated(page: currentPage)
    case MovieCategory.trending.rawValue:
      endpoint = MovieEndpoint.trending(page: currentPage)
    default:
      break
    }
    
    return endpoint
  }
  
  
  // MARK: - Init
  init(mediaItems: [TMDBMovieResult], category: MovieCategory) {
    self.mediaItems = mediaItems
    self.category = category.rawValue
    self.service = MoviesService()
  }
  
  
  // MARK: - Methods
  public func loadMoreItems(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: categoryEndpoint,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.totalPages = response.totalPages
          strongSelf.mediaItems.append(contentsOf: response.results)
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
