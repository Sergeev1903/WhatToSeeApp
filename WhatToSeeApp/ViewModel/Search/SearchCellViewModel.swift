//
//  SearchCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import Foundation


protocol SearchCellViewModelProtocol: AnyObject {
  var mediaPosterURL: URL { get }
  var mediaTitle: String { get }
  init(media: TMDBMovieResult)
}


class SearchCellViewModel: SearchCellViewModelProtocol {
  
  private let media: TMDBMovieResult
  
  var mediaPosterURL: URL {
    media.posterURL
  }
  
  var mediaTitle: String {
    media.title ?? ""
  }
  
  required init(media: TMDBMovieResult) {
    self.media = media
  }
 
}
