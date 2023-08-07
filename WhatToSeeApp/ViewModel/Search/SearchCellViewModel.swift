//
//  SearchCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import Foundation


protocol SearchCellViewModelProtocol: AnyObject {
  var media: TMDBMovieResult { get }
  var mediaBackdropURL: URL { get }
  var mediaTitleWithReleaseYear: String { get }
  var mediaTitle: String { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseYear: String { get }
  init(media: TMDBMovieResult)
}


class SearchCellViewModel: SearchCellViewModelProtocol {
  
  // MARK: - Properties
  public let media: TMDBMovieResult
  
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
  
  var mediaReleaseYear: String {
    let year = media.releaseDate?.components(separatedBy: "-")
    return year?.first ?? ""
  }
  
  var mediaTitleWithReleaseYear: String {
    mediaTitle + "\n" + mediaReleaseYear
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
  }
  
}
