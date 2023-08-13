//
//  DetailViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import Foundation


protocol DetailViewModelProtocol: AnyObject {
  var favoriteStatusText: String { get set }
  var isFavorite: Bool { get }
  var mediaTitle: String { get }
  var mediaBackdropURL: URL? { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseDate: String { get }
  var mediaOverview: String { get }
  var detailGenres: String { get }
  var detailTrailerUrl: URL? { get }
  func getMovieDetails(completion: @escaping () -> Void)
  func addToFovorite(completion: @escaping () -> Void)
  func removeFromFovorite(completion: @escaping () -> Void)
}


class DetailViewModel: DetailViewModelProtocol {
  
  
  // MARK: - Properties
  private let mediaItem: TMDBMovieResult
  private var mediaGenres: [Genre] = []
  private var mediaTrailers: [Video] = []

  private let service: MoviesServiceable
  
  public var favoriteStatusText: String = ""


  var isFavorite: Bool {
    MovieFavoritesManager.shared.isFavorite(movieID: mediaItem.id!)
  }
  
  var mediaBackdropURL: URL? {
    mediaItem.backdropURL
  }
  
  var mediaTitle: String {
    mediaItem.title ?? ""
  }
  
  var mediaVoteAverage: String {
    return mediaItem.voteAverage == 0 ? "New":
    String(format: "%.1f", mediaItem.voteAverage!)
  }
  
  var mediaReleaseDate: String {
    mediaItem.releaseDate ?? ""
  }
  
  var mediaOverview: String {
    mediaItem.overview ?? ""
  }
  
  var detailGenres: String {
    return  mediaGenres.compactMap {$0.name}.lazy.joined(separator: ", ")
  }
  
  var detailTrailerUrl: URL? {
      var url: URL?
    
      mediaTrailers.forEach { trailer in
          if trailer.official || trailer.name.contains("Official Trailer") {
              url = trailer.keyURL
              return // Exit the loop closure once a suitable URL is found
          }
      }
      
      return url
  }
  
  
  // MARK: - Init
  init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
    self.service = MoviesService()
  }
  
  
  // MARK: - Methods
  public func getMovieDetails(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.movieDetails(id: mediaItem.id!),
      responseModel: TMDBMovieResult.self) { [weak self] result in
        
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let details):
          strongSelf.mediaGenres = details.genres ?? []
          strongSelf.mediaTrailers = details.videos?.results ?? []
        case .failure(let error):
          print(error.customMessage)
        }
        completion()
      }
  }
  
  public func addToFovorite(completion: @escaping () -> Void) {
    service.getMedia(endpoint: MoviesEndpoint.addFavoriteMovie(movieId: mediaItem.id!), responseModel: TMDBMovieResult.self) {[weak self] response in
      
      guard let strongSelf = self else { return }
      
      switch response {
      case .success:
        strongSelf.favoriteStatusText = "Added"
        MovieFavoritesManager.shared.addToFavorites(
          movieID: strongSelf.mediaItem.id!)
        
      case .failure(let error):
        strongSelf.favoriteStatusText = "\(error.customMessage)"
      }
      completion()
    }
  }
  
  public func removeFromFovorite(completion: @escaping () -> Void) {
    service.getMedia(endpoint: MoviesEndpoint.removeFavoriteMovie(movieId: mediaItem.id!), responseModel: TMDBMovieResult.self) {[weak self] response in
      
      guard let strongSelf = self else { return }
      
      switch response {
      case .success:
        strongSelf.favoriteStatusText = "Removed"
        MovieFavoritesManager.shared.removeFromFavorites(
          movieID: strongSelf.mediaItem.id!)
        
      case .failure(let error):
        strongSelf.favoriteStatusText = "\(error.customMessage)"
      }
      completion()
    }
  }
  
}
