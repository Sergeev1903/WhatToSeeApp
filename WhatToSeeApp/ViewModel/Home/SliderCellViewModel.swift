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
  init(media: TMDBMovieResult)
}


class SliderCellViewModel: SliderCellViewModelProtocol {
  
  // MARK: - Properties
  private var media: TMDBMovieResult
  
  var mediaPosterURL: URL {
    media.posterURL
  }
  
  var mediaBackdropURL: URL {
    media.backdropURL
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
  }
  
}
