//
//  SliderItemViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderItemViewModelProtocol: AnyObject {
  var media: TMDBMovieResult! { get }
  var mediaData: Data? { get }
  init(media: TMDBMovieResult)
}


class SliderItemViewModel: SliderItemViewModelProtocol {
 
  // MARK: - Properties
  private let service: MoviesServiceable
  var media: TMDBMovieResult!
  
  var mediaData: Data? {
    let data = try? Data(contentsOf: media.posterURL)
    return data
  }
  
  
  // MARK: - Init
  required init(media: TMDBMovieResult) {
    self.media = media
    self.service = MoviesService()
  }

}
