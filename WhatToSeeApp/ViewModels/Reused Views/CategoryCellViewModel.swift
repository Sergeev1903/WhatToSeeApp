//
//  CategoryCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellViewModelProtocol {
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class CategoryCellViewModel: CategoryCellViewModelProtocol {
  
  // MARK: - Properties
  private let mediaItems: [TMDBMovieResult]
  
  
  // MARK: - Init
  init(mediaItems: [TMDBMovieResult]) {
    self.mediaItems = mediaItems
  }
  
  
  // MARK: - Methods
  public func numberOfItemsInSection() -> Int {
    mediaItems.count
  }
  
  public func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return CategoryCellItemViewModel(mediaItem: mediaItem)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let mediaItem = mediaItems[indexPath.item]
      return DetailViewModel(mediaItem: mediaItem)
    }
  
}
