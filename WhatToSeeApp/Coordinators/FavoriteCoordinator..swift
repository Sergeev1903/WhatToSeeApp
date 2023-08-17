//
//  FavoriteCoordinator..swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 14.08.2023.
//

import UIKit


class FavoriteCoordinator: Coordinator {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  let navigationController: UINavigationController
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
    self.navigationController = UINavigationController()
  }
  
  
  // MARK: - FavoriteCoordinator start
  func start() {
    let favoriteViewModel = FavoriteViewModel(service: service)
    let favoriteViewController = FavoriteViewController(favoriteViewModel)
    favoriteViewController.coordinator = self
    
    navigationController.viewControllers = [favoriteViewController]
  }
  
}


extension FavoriteCoordinator {
  
  // DetailViewController
  func showDetail(_ viewModel: DetailViewModelProtocol) {
    let vc = DetailViewController(viewModel)
    navigationController.pushViewController(vc, animated: true)
  }
  
}
