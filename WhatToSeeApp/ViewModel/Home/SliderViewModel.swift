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
  init(service: MoviesServiceable)
  func getMedia(completion: @escaping () -> Void)
  func numberOfItemsInSection() -> Int
  func cellForItemAt(
    indexPath: IndexPath) -> SliderCellViewModelProtocol
  func didSelectItemAt(
   indexPath: IndexPath) -> DetailViewModelProtocol
}


class SliderViewModel: SliderViewModelProtocol {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  var mediaItems: [TMDBMovieResult] = []
  
  
  weak var delegate: SliderViewDelegate?
  
  // MARK: - Init
  required init(service: MoviesServiceable) {
    self.service = service
  }
  
  // MARK: - Networking
  func getMedia(completion: @escaping () -> Void) {
    service.getUpcoming {[weak self] result in
      guard let strongSelf = self else {
        return
      }
      switch result {
      case .success(let movieResponse):
        strongSelf.mediaItems = movieResponse.results
      case .failure(let error):
        print(error.customMessage)
      }
      completion()
    }
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
