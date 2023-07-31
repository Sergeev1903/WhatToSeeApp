//
//  DetailViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import Foundation


protocol DetailViewModelProtocol: AnyObject {
  var media: TMDBMovieResult { get }
  var mediaBackdropURL: URL { get }
  var mediaTitle: String { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseDate: String { get }
  var mediaOverview: String { get }
  init(media: TMDBMovieResult)
  
  //MARK: - Movie details
  //  func getMultiplyRequest(completion: @escaping () -> Void)
  func getMovieGenres(completion: @escaping () -> Void)
  func getMovieTrailers(completion: @escaping () -> Void)
  var detailGenres: String { get }
  var detailTrailerUrl: String { get }
}


class DetailViewModel: DetailViewModelProtocol {
  
  // MARK: - Properties
  let media: TMDBMovieResult
  
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
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
    self.service = MoviesService()
  }
  
  
  //MARK: - Movie details
  let service: MoviesService
  let dispatchGroup = DispatchGroup()
  
  var mediaGenres: [Genre] = [] {
    didSet {
      print(mediaGenres.forEach({ genre in
        print(genre.name)
      }))
    }
  }
  var mediaTrailers: [Video] = []
  
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
  
  
  func getMovieGenres(completion: @escaping () -> Void) {
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
  
  
  func getMovieTrailers(completion: @escaping () -> Void) {
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
