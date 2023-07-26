//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation


protocol HomeViewModelProtocol: AnyObject {
  var nowPlayingMovies: [TMDBMovieResult] { get }
  var popularMovies: [TMDBMovieResult] { get }
  var topRatedMovies: [TMDBMovieResult] { get }
  var trendingMovies: [TMDBMovieResult] { get }
  func getMovieCategories(completion: @escaping () -> Void)
  func numberOfSections() -> Int
  func numberOfRowsInSection() -> Int
  func cellForRowAt(
    indexPath: IndexPath,
    mediaItems: [TMDBMovieResult]) -> CategoryCellViewModelProtocol
}


class HomeViewModel: HomeViewModelProtocol {
  
  // MARK: - Properties
  var nowPlayingMovies: [TMDBMovieResult] = []
  var popularMovies: [TMDBMovieResult] = []
  var topRatedMovies: [TMDBMovieResult] = []
  var trendingMovies: [TMDBMovieResult] = []
  private let service: MoviesServiceable
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods
  func getMovieCategories(completion: @escaping () -> Void) {
    getNowPlayingMovies()
    getPopularMovies()
    getTopRatedMovies()
    getTrendingMovies()
    completion()
  }
  
  
  // MARK: -
  public func numberOfSections() -> Int { return 4 }
  
  public func numberOfRowsInSection() -> Int { return 1 }
  
  public func cellForRowAt(
    indexPath: IndexPath,
    mediaItems: [TMDBMovieResult]) -> CategoryCellViewModelProtocol {
      
      return CategoryCellViewModel(mediaItems: mediaItems)
    }
 
  private func getNowPlayingMovies() {
    service.getMedia(
      endpoint: MoviesEndpoint.nowPlaying,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let result):
          strongSelf.nowPlayingMovies = result.results
        case .failure(let error):
          print(error.customMessage)
        }
      }
  }
  
  private func getPopularMovies() {
    service.getMedia(
      endpoint: MoviesEndpoint.popular,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let result):
          strongSelf.popularMovies = result.results
        case .failure(let error):
          print(error.customMessage)
        }
      }
  }
  
  private func getTopRatedMovies() {
    service.getMedia(
      endpoint: MoviesEndpoint.topRated,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let result):
          strongSelf.topRatedMovies = result.results
        case .failure(let error):
          print(error.customMessage)
        }
      }
  }
  
  private func getTrendingMovies() {
    service.getMedia(
      endpoint: MoviesEndpoint.trending,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let result):
          strongSelf.trendingMovies = result.results
        case .failure(let error):
          print(error.customMessage)
        }
      }
  }
  
}


