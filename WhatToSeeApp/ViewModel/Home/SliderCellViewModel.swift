//
//  SliderItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderCellViewModelProtocol: AnyObject {
  var media: TMDBMovieResult! { get }
  var mediaPosterURL: URL { get }
  init(media: TMDBMovieResult)
}


class SliderCellViewModel: SliderCellViewModelProtocol {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  var media: TMDBMovieResult!
  
  var mediaPosterURL: URL {
    media.posterURL
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
    self.service = MoviesService()
  }
  
}
