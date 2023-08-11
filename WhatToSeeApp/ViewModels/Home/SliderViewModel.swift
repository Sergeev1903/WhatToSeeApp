//
//  SliderViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderViewModelProtocol: AnyObject {
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> SliderCellViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class SliderViewModel: SliderViewModelProtocol {
  
  // MARK: - Properties
  private var mediaItems: [TMDBMovieResult]
  
  
  // MARK: - Init
  init(mediaItems: [TMDBMovieResult]) {
    self.mediaItems = mediaItems
  }
  
  
  // MARK: - Methods
  public func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  public func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return SliderCellViewModel(mediaItem: mediaItem)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return DetailViewModel(mediaItem: mediaItem)
    }
  
}
