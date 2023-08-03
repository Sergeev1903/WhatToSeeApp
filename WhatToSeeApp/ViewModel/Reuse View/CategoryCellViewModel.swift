//
//  CategoryCellViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 25.07.2023.
//

import Foundation


protocol CategoryCellDelegate: AnyObject {
  func didTapCategoryCell(
    _ categoryCell: CategoryCell, viewModel: DetailViewModelProtocol)
}

protocol CategoryCellViewModelProtocol {
  var delegate: CategoryCellDelegate? { get set }
  init(mediaItems: [TMDBMovieResult])
  func numberOfItemsInSection() -> Int
  func cellForItemAt(indexPath: IndexPath) -> CategoryCellItemViewModelProtocol
  func didSelectItemAt(indexPath: IndexPath) -> DetailViewModelProtocol
}


class CategoryCellViewModel: CategoryCellViewModelProtocol {
  
  // MARK: - Properties
  private let mediaItems: [TMDBMovieResult]
  
  // MARK: - Delegate
  weak var delegate: CategoryCellDelegate?
  
  
  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult]) {
    self.mediaItems = mediaItems
  }
  
  
  // MARK: -
  public func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  public func cellForItemAt(
    indexPath: IndexPath) -> CategoryCellItemViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return CategoryCellItemViewModel(media: media)
    }
  
  public func didSelectItemAt(
    indexPath: IndexPath) -> DetailViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return DetailViewModel(media: media)
    }
  
}
