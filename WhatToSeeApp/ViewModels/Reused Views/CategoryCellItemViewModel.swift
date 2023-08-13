//
//  CategoryCellItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellItemViewModelProtocol {
  var mediaPosterURL: URL? { get }
  var mediaVoteCount: Double { get }
  var mediaVoteAverage: String { get }
}


class CategoryCellItemViewModel: CategoryCellItemViewModelProtocol {
  
  // MARK: - Properties
  private let mediaItem: TMDBMovieResult
  
  var mediaPosterURL: URL? {
    mediaItem.posterURL
  }
  
  var mediaVoteCount: Double {
    return mediaItem.voteAverage ?? 0
  }
  
  var mediaVoteAverage: String {
    return mediaItem.voteAverage == 0 ? "New":
    String(format: "%.1f", mediaItem.voteAverage!)
  }
  
  
  // MARK: - Init
  required init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
  }
  
}
