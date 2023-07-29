//
//  CategoryCellItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellItemViewModelProtocol {
  var media: TMDBMovieResult { get }
  var mediaPosterURL: URL { get }
  var mediaVoteAverage: String { get }
  init(media: TMDBMovieResult)
}


class CategoryCellItemViewModel: CategoryCellItemViewModelProtocol {
  
  // MARK: - Properties
  var media: TMDBMovieResult
  
  var mediaPosterURL: URL {
    media.posterURL
  }
  
  var mediaVoteAverage: String {
    return media.voteAverage == 0 ? "New":
    String(format: "%.1f", media.voteAverage!)
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
  }
  
}
