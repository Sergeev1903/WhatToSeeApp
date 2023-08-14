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
  func didTapSeeAllButton(
    mediaItems: [TMDBMovieResult],
    category: MovieCategory) -> ShowAllViewModelProtocol
}


class HomeViewModel: HomeViewModelProtocol {
  
  // MARK: - Properties
  public var upcomingMovies: [TMDBMovieResult] = []
  public var nowPlayingMovies: [TMDBMovieResult] = []
  public var popularMovies: [TMDBMovieResult] = []
  public var topRatedMovies: [TMDBMovieResult] = []
  public var trendingMovies: [TMDBMovieResult] = []
  
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
  
  public func numberOfSections() -> Int {
    MovieCategory.allCases.count
  }
  
  public func numberOfRowsInSection() -> Int {
    return 1
  }
  
  public func cellForRowAt(
    indexPath: IndexPath,
    mediaItems: [TMDBMovieResult]) -> CategoryCellViewModelProtocol {
      return CategoryCellViewModel(mediaItems: mediaItems)
    }
  
  public func didTapSeeAllButton(
    mediaItems: [TMDBMovieResult],
    category: MovieCategory) -> ShowAllViewModelProtocol {
      return ShowAllViewModel(mediaItems: mediaItems, category: category)
    }
  
}


// MARK: - Network requests
extension HomeViewModel {
  
  private func getUpcomingMovies() {
    service.getMedia(
      endpoint: MovieEndpoint.upcoming,
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.upcomingMovies = response.results
        case .failure(let error):
          print(error.message)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
  private func getNowPlayingMovies() {
    service.getMedia(
      endpoint: MovieEndpoint.nowPlaying(page: 1),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.nowPlayingMovies = response.results
        case .failure(let error):
          print(error.message)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
  private func getPopularMovies() {
    service.getMedia(
      endpoint: MovieEndpoint.popular(page: 1),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.popularMovies = response.results
        case .failure(let error):
          print(error.message)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
  private func getTopRatedMovies() {
    service.getMedia(
      endpoint: MovieEndpoint.topRated(page: 1),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.topRatedMovies = response.results
        case .failure(let error):
          print(error.message)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
  private func getTrendingMovies() {
    service.getMedia(
      endpoint: MovieEndpoint.trending(page: 1),
      responseModel: TMDBMovieResponse.self) {[weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let response):
          strongSelf.trendingMovies = response.results
        case .failure(let error):
          print(error.message)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
}
