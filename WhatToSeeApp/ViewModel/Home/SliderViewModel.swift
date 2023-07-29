//
//  SliderViewModel.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import Foundation


protocol SliderViewDelegate: AnyObject {
  func didTapSliderView(
    _ categoryCell: SliderView, viewModel: DetailViewModelProtocol)
}

protocol SliderViewModelProtocol: AnyObject {
  var mediaItems: [TMDBMovieResult] { get }
  var delegate: SliderViewDelegate? { get set}
  init(mediaItems: [TMDBMovieResult], delegate: SliderViewDelegate?)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol
  func didSelectItemAt(
   indexPath: IndexPath) -> DetailViewModelProtocol
}


class SliderViewModel: SliderViewModelProtocol {
  
  // MARK: - Properties
  var mediaItems: [TMDBMovieResult] = []
  
  // MARK: - Delegate
  weak var delegate: SliderViewDelegate?
  
  
  // MARK: - Init
  required init(mediaItems: [TMDBMovieResult], delegate: SliderViewDelegate? = nil) {
    self.mediaItems = mediaItems
    self.delegate = delegate
  }

    
  // MARK: - Configure slider collection
  func numberOfItemsInSection() -> Int {
    return mediaItems.count
  }
  
  func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol {
      let media = mediaItems[indexPath.item]
      return SliderCellViewModel(media: media)
    }
  
  func didSelectItemAt(
   indexPath: IndexPath) -> DetailViewModelProtocol {
    let media = mediaItems[indexPath.item]
    return DetailViewModel(media: media)
   }
  
}
