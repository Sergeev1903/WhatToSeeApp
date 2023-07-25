//
//  CategoryCellItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellItemViewModelProtocol {
  var media: TMDBMovieResult { get }
  var mediaImageData: Data? { get }
  init(media: TMDBMovieResult)
}


class CategoryCellItemViewModel: CategoryCellItemViewModelProtocol {
  
  // MARK: - Properties
  var media: TMDBMovieResult
  
  var mediaImageData: Data? {
    let data = try? Data(contentsOf: media.posterURL)
    return data
  }
  
  required init(media: TMDBMovieResult) {
    self.media = media
  }
  
}
