//
//  FavoriteCoordinator..swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 14.08.2023.
//

import UIKit


class FavoriteCoordinator: Coordinator {
  
  private let service: MoviesServiceable
  let navigationController: UINavigationController
  
  init(service: MoviesServiceable) {
    self.service = service
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let favoriteViewModel = FavoriteViewModel(service: service)
    let favoriteViewController = FavoriteViewController(favoriteViewModel)
    
    navigationController.viewControllers = [favoriteViewController]
  }
  
}
