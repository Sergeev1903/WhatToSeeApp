//
//  SliderItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderCellViewModelProtocol {
  var mediaPosterURL: URL? { get }
  var mediaBackdropURL: URL? { get }
}


struct SliderCellViewModel: SliderCellViewModelProtocol {
  
  // MARK: - Properties
  private var mediaItem: TMDBMovieResult
  
  var mediaPosterURL: URL? {
    mediaItem.posterURL
  }
  
  var mediaBackdropURL: URL? {
    mediaItem.backdropURL
  }
  
  
  // MARK: - Init
  init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
  }
  
}
