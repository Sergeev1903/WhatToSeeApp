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
  }
  
}
