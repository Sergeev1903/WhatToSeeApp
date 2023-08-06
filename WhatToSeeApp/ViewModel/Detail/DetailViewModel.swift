//
//  DetailViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import Foundation


protocol DetailViewModelProtocol: AnyObject {
  var mediaBackdropURL: URL { get }
  var mediaTitle: String { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseDate: String { get }
  var mediaOverview: String { get }
  
  var detailGenres: String { get }
  var detailTrailerUrl: String { get }
  
  init(media: TMDBMovieResult)
  //  func getMultiplyRequest(completion: @escaping () -> Void)
  func getMovieGenres(completion: @escaping () -> Void)
  func getMovieTrailers(completion: @escaping () -> Void)
  
}


class DetailViewModel: DetailViewModelProtocol {
  
  // MARK: - Properties
  private let media: TMDBMovieResult

  private var mediaGenres: [Genre] = []
  private var mediaTrailers: [Video] = []
  
  private let service: MoviesServiceable
  private let dispatchGroup = DispatchGroup()
  
  var mediaBackdropURL: URL {
    media.backdropURL
  }
  
  var mediaTitle: String {
    media.title ?? ""
  }
  
  var mediaVoteAverage: String {
    return media.voteAverage == 0 ? "New":
    String(format: "%.1f", media.voteAverage!)
  }
  
  var mediaReleaseDate: String {
    media.releaseDate ?? ""
  }
  
  var mediaOverview: String {
    media.overview ?? ""
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
  required init(media: TMDBMovieResult) {
    self.media = media
    self.service = MoviesService()
  }
  
  
  // MARK: - Methods
  //  public func getMultiplyRequest(completion: @escaping () -> Void) {
  //    dispatchGroup.enter()
  //    getMovieDetail()
  //    dispatchGroup.enter()
  //    getMovieTrailers()
  //
  //    dispatchGroup.notify(queue: .main) {
  //      completion()
  //    }
  //  }
  
  public func getMovieGenres(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.movieGenres(id: media.id!),
      responseModel: Genres.self) { [weak self] result in
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let genres):
          strongSelf.mediaGenres = genres.genres
        case .failure(let error):
          print(error.customMessage)
        }
        //      strongSelf.dispatchGroup.enter()
        completion()
      }
  }
  
  public func getMovieTrailers(completion: @escaping () -> Void) {
    service.getMedia(
      endpoint: MoviesEndpoint.movieTrailers(id: media.id!),
      responseModel: Videos.self) { [weak self] result in
        guard let strongSelf = self else { return }
        
        switch result {
        case .success(let trailers):
          strongSelf.mediaTrailers = trailers.results
        case .failure(let error):
          print(error.customMessage)
        }
        //      strongSelf.dispatchGroup.enter()
        completion()
      }
  }
  
}
