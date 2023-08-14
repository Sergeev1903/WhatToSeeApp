//
//  SearchViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import Foundation


protocol SearchViewModelProtocol: AnyObject {
  func searchMovies(
    searchText: String, page: Int, completion: @escaping () -> Void)
  func numberOfRowsInSection() -> Int
  func cellForRowAt(indexPath: IndexPath) -> SearchCellViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class SearchViewModel: SearchViewModelProtocol {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  private var searchItems: [TMDBMovieResult] = []
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods
  public func searchMovies(
    searchText: String, page: Int, completion: @escaping () -> Void) {
      service.getMedia(
        endpoint: MovieEndpoint.searchMovie(
          searchText: searchText, page: 1),
        responseModel: TMDBMovieResponse.self) {[weak self] result in
          
          guard let strongSelf = self else { return }
          
          switch result {
          case .success(let response):
            strongSelf.searchItems = response.results.filter { $0.backdropPath != nil }
          case .failure(let error):
            print(error.message)
          }
          completion()
        }
    }
  
  public func numberOfRowsInSection() -> Int {
    searchItems.count
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
