//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation

protocol HomeViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  func getMedia(completion: @escaping () -> Void)
}


class HomeViewModel: HomeViewModelProtocol {
  
  var mediaItems: [TMDBMovieResult] = []

  func getMedia(completion: @escaping () -> Void) {
    let urlPath = "https://api.themoviedb.org/3/movie/upcoming?api_key=4f586e20aeada54a820a56ba58751747"
    guard let url = URL(string: urlPath) else { return}
    
    NetworkFetchData.shared.fetchData(from: url) { [weak self] (result: TMDBMovieResponse) in
      guard let strongSelf = self else { return }
      strongSelf.mediaItems = result.results
      completion()
    }
  }

}
