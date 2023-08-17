//
//  HomeCoordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 13.08.2023.
//

import UIKit


class HomeCoordinator: Coordinator {
  
  private let service: MoviesServiceable
  let navigationController: UINavigationController
  
  init(service: MoviesServiceable) {
    self.service = service
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let homeViewModel = HomeViewModel(service: service)
    let homeViewController = HomeViewController(homeViewModel)

    navigationController.viewControllers = [homeViewController]
  }

}
