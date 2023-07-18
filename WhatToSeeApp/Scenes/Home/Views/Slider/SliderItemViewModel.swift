//
//  SliderItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation

protocol SliderItemViewModelProtocol: AnyObject {
  var media: TMDBMovieResult! { get }
  var mediaImage: Data? { get }
  init(media: TMDBMovieResult)
}


class SliderItemViewModel: SliderItemViewModelProtocol {
 
  // MARK: - Properties
  private let service: MoviesServiceable
  var media: TMDBMovieResult!
  
  var mediaImage: Data? {
    service.loadData(url: media.posterURL)
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
    self.service = MoviesService()
  }

}
