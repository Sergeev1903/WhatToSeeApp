//
//  ShowAllViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import Foundation


protocol ShowAllViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  var title: String { get }
  init(mediaItems: [TMDBMovieResult], category: MovieCategory)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
  
}


class ShowAllViewModel: ShowAllViewModelProtocol {
  
  // MARK: - Properties
  let mediaItems: [TMDBMovieResult]
  let title: String
  
  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult], category: MovieCategory) {
    self.mediaItems = mediaItems
    self.title = category.rawValue
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
  
  func didSelectItemAt(
   indexPath: IndexPath) -> DetailViewModelProtocol {
    let media = mediaItems[indexPath.item]
    return DetailViewModel(media: media)
   }
}
