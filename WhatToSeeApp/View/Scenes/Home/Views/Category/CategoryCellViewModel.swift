//
//  CategoryCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellViewModelProtocol {
  var mediaItems: [TMDBMovieResult] { get }
  init(mediaItems: [TMDBMovieResult])
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
}


class CategoryCellViewModel: CategoryCellViewModelProtocol {
  
  // MARK: - Properties
  let mediaItems: [TMDBMovieResult]
  
  
  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult]) {
    self.mediaItems = mediaItems
  }
  
  
  // MARK: - Methods
  func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
    let media = mediaItems[indexPath.item]
    return CategoryCellItemViewModel(media: media)
  }
  
}
