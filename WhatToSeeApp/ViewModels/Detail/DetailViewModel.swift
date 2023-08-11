//
//  DetailViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import Foundation


protocol DetailViewModelProtocol: AnyObject {
  var favoriteStatus: String { get }
  var mediaItemId: Int { get }
  var mediaBackdropURL: URL { get }
  var mediaTitle: String { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseDate: String { get }
  var mediaOverview: String { get }
  
  var detailGenres: String { get }
  var detailTrailerUrl: String { get }
  func getMultiplyRequest(completion: @escaping () -> Void)
  
  func addToFovorite(movieId: Int, completion: @escaping () -> Void)
  func removeFromFovorite(movieId: Int, completion: @escaping () -> Void) 
}


class DetailViewModel: DetailViewModelProtocol {
  
  // MARK: - Properties
  private let mediaItem: TMDBMovieResult
  
  private var mediaGenres: [Genre] = []
  private var mediaTrailers: [Video] = []
  
  private let service: MoviesServiceable
  private let dispatchGroup = DispatchGroup()
  
  
  var favoriteStatus: String = ""
  
  var mediaItemId: Int {
    mediaItem.id!
  }
  
  var mediaBackdropURL: URL {
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
  
  var detailTrailerUrl: String {
    var key = ""
    for trailer in mediaTrailers {
      switch trailer.name {
      case "Official Trailer": key = trailer.key
      case _ : key = trailer.key
      }
    }
    return "https://www.youtube.com/watch?v=\(key))"
  }
  
  
  // MARK: - Init
  init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
    self.service = MoviesService()
  }
  
  
  // MARK: - Methods
  public func getMultiplyRequest(completion: @escaping () -> Void) {
    dispatchGroup.enter()
    getMovieGenres()
    dispatchGroup.enter()
    getMovieTrailers()
    
    dispatchGroup.notify(queue: .main) {
      completion()
    }
  }
  
  
  public func addToFovorite(movieId: Int, completion: @escaping () -> Void) {
    service.getMedia(endpoint: MoviesEndpoint.addFavoriteMovie(movieId: movieId), responseModel: TMDBMovieResult.self) {[weak self] response in
      guard let strongSelf = self else { return }
      
      switch response {
      case .success:
        print("success added")
        strongSelf.favoriteStatus = "Added to favorite"
      case .failure(let error):
        print(error.customMessage)
        strongSelf.favoriteStatus = "\(error.customMessage)"
      }
      completion()
    }
  }
  
  // FIXME: -
  public func removeFromFovorite(movieId: Int, completion: @escaping () -> Void) {
    service.getMedia(endpoint: MoviesEndpoint.removeFavoriteMovie(movieId: movieId), responseModel: TMDBMovieResult.self) {[weak self] response in
       guard let strongSelf = self else { return }
       
       switch response {
       case .success:
         print("success removed")
         strongSelf.favoriteStatus = "Removed to favorite"
       case .failure(let error):
         print(error.customMessage)
         strongSelf.favoriteStatus = "\(error.customMessage)"
       }
      completion()
     }
   }
  
}


// MARK: - Network requests
extension DetailViewModel {
  
  private func getMovieGenres() {
    service.getMedia(
      endpoint: MoviesEndpoint.movieGenres(id: mediaItem.id!),
      responseModel: Genres.self) { [weak self] result in
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let genres):
          strongSelf.mediaGenres = genres.genres
        case .failure(let error):
          print(error.customMessage)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
  private func getMovieTrailers() {
    service.getMedia(
      endpoint: MoviesEndpoint.movieTrailers(id: mediaItem.id!),
      responseModel: Videos.self) { [weak self] result in
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let trailers):
          strongSelf.mediaTrailers = trailers.results
        case .failure(let error):
          print(error.customMessage)
        }
        strongSelf.dispatchGroup.leave()
      }
  }
  
}
