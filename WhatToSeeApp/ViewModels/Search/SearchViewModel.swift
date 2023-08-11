//
//  SearchViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import Foundation


protocol SearchViewModelProtocol: AnyObject {
  var currentPage: Int { get set }
  var totalPages: Int { get set }
  func searchMovies(searchText: String, page: Int, completion: @escaping () -> Void)
  func numberOfRowsInSection() -> Int
  func cellForRowAt(indexPath: IndexPath) -> SearchCellViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class SearchViewModel: SearchViewModelProtocol {
  
  // MARK: - Properties
  public var currentPage: Int = 1
  public var totalPages: Int = 1
  
  private let service: MoviesServiceable
  private var searchItems: [TMDBMovieResult] = []
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods
  public func searchMovies(searchText: String,
                           page: Int,
                           completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.searchMovie(
        searchText: searchText, page: currentPage),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let response):
          strongSelf.totalPages = response.totalPages
          strongSelf.searchItems = response.results.filter { $0.backdropPath != nil }
        case .failure(let error):
          print(error.customMessage)
        }
        completion()
      }
  }
  
  public func numberOfRowsInSection() -> Int {
    return searchItems.count
  }
  
  public func cellForRowAt(
    indexPath: IndexPath) -> SearchCellViewModelProtocol {
      let mediaItem = searchItems[indexPath.row]
      return SearchCellViewModel(mediaItem: mediaItem)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let mediaItem = searchItems[indexPath.item]
      return DetailViewModel(mediaItem: mediaItem)
    }
  
}
