//
//  HomeViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation
import UIKit

protocol HomeViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  func getMedia(completion: @escaping () -> Void)
  var mediaImages: [UIImage] { get }
  func loadImages()
}


class HomeViewModel: HomeViewModelProtocol {
  private let service: MoviesServiceable
  
  var mediaItems: [TMDBMovieResult] = []
  
  var mediaImages: [UIImage] = [] {
    didSet {
      print(mediaImages.count)
    }
  }
  
  init(service: MoviesServiceable) {
    self.service = service
  }
  
  func getMedia(completion: @escaping () -> Void) {
    service.getUpcoming {[weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let movieResponse):
        strongSelf.mediaItems = movieResponse.results
        strongSelf.loadImages()
      case .failure(let error):
        print(error.customMessage)
      }
      completion()
    }
  }
  
  func loadImages() {
    print("loadImages start")
    for item in mediaItems {
      
      DispatchQueue.global(qos: .userInitiated).async {
        guard let data = self.service.loadData(url: item.posterURL) else { return }
        guard let image = UIImage(data: data) else { return }
        
        DispatchQueue.main.async {
          self.mediaImages.append(image)
        }
      }
    }
    print("loadImages end")
  }
  
}


