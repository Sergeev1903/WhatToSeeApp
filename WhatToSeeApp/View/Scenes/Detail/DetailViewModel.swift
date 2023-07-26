//
//  DetailViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import Foundation


protocol DetailViewModelProtocol: AnyObject {
  var media: TMDBMovieResult { get }
  var mediaTitle: String { get }
  init(media: TMDBMovieResult)
}


class DetailViewModel: DetailViewModelProtocol {
  
  // MARK: - Properties
  let media: TMDBMovieResult
  
  var mediaTitle: String {
    media.title ?? ""
  }
  
  required init(media: TMDBMovieResult) {
    self.media = media
  }
  
}
