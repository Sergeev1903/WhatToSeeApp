//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation


protocol HomeViewModelProtocol: AnyObject {
  var upcomingMovies: [TMDBMovieResult] { get }
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
//  func initSliderItems() -> SliderViewModelProtocol
}


class HomeViewModel: HomeViewModelProtocol {

  // MARK: - Properties
  var upcomingMovies: [TMDBMovieResult] = []
  var nowPlayingMovies: [TMDBMovieResult] = []
  var popularMovies: [TMDBMovieResult] = []
  var topRatedMovies: [TMDBMovieResult] = []
  var trendingMovies: [TMDBMovieResult] = []
  private let service: MoviesServiceable
  private let dispatchGroup = DispatchGroup()

  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  
  // MARK: - Methods
  public func getMovieCategories(completion: @escaping () -> Void) {
    dispatchGroup.enter()
    getUpcomingMovies()
    dispatchGroup.enter()
    getNowPlayingMovies()
    dispatchGroup.enter()
    getPopularMovies()
    dispatchGroup.enter()
    getTopRatedMovies()
    dispatchGroup.enter()
    getTrendingMovies()
    
    dispatchGroup.notify(queue: .main) {
      completion()
    }
  }
  
  
  // MARK: -
  public func numberOfSections() -> Int {
    return MovieCategory.allCases.count
  }
  
  public func numberOfRowsInSection() -> Int { return 1 }
  
  public func cellForRowAt(
    indexPath: IndexPath,
    mediaItems: [TMDBMovieResult]) -> CategoryCellViewModelProtocol {
    return CategoryCellViewModel(mediaItems: mediaItems)
  }
  
//  public func initSliderItems() -> SliderViewModelProtocol {
//    return SliderViewModel(mediaItems: upcomingMovies)
//  }

}


// MARK: - Network requests
extension HomeViewModel {
  
  private func getUpcomingMovies() {
    service.getMedia(
      endpoint: MoviesEndpoint.upcoming,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        guard let strongSelf = self else {
          return
        }
        switch result {
        case .success(let result):
          strongSelf.upcomingMovies = result.results
        case .failure(let error):
          print(error.customMessage)
        }
        strongSelf.dispatchGroup.leave()
      }
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
        strongSelf.dispatchGroup.leave()
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
        strongSelf.dispatchGroup.leave()
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
        strongSelf.dispatchGroup.leave()
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
        strongSelf.dispatchGroup.leave()
      }
  }
  
}
