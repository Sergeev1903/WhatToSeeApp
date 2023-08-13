//
//  SearchCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import Foundation


protocol SearchCellViewModelProtocol: AnyObject {
  var mediaBackdropURL: URL? { get }
  var mediaTitleWithReleaseYear: String { get }
  var mediaTitle: String { get }
  var mediaVoteCount: Double { get }
  var mediaVoteAverage: String { get }
  var mediaReleaseYear: String { get }
}


class SearchCellViewModel: SearchCellViewModelProtocol {
  
  // MARK: - Properties
  private let mediaItem: TMDBMovieResult
  
  var mediaBackdropURL: URL? {
    mediaItem.backdropURL
  }
  
  var mediaTitle: String {
    mediaItem.title ?? ""
  }
  
  var mediaVoteCount: Double {
    mediaItem.voteAverage ?? 0
  }
  
  var mediaVoteAverage: String {
    mediaItem.voteAverage == 0 ? "New":
    String(format: "%.1f", mediaItem.voteAverage!)
  }
  
  var mediaReleaseYear: String {
    let year = mediaItem.releaseDate?.components(separatedBy: "-")
    return year?.first ?? ""
  }
  
  var mediaTitleWithReleaseYear: String {
    mediaTitle + "\n" + mediaReleaseYear
  }
  
  
  // MARK: - Init
  init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
  }
  
}
