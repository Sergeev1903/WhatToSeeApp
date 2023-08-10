//
//  SliderItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderCellViewModelProtocol: AnyObject {
  var mediaPosterURL: URL { get }
  var mediaBackdropURL: URL { get }
}


class SliderCellViewModel: SliderCellViewModelProtocol {
  
  // MARK: - Properties
  private var mediaItem: TMDBMovieResult
  
  var mediaPosterURL: URL {
    mediaItem.posterURL
  }
  
  var mediaBackdropURL: URL {
    mediaItem.backdropURL
  }
  
  
  // MARK: - Init
  required init(mediaItem: TMDBMovieResult) {
    self.mediaItem = mediaItem
  }
  
}
