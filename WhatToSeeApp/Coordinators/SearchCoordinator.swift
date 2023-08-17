//
//  SearchCoordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 14.08.2023.
//

import UIKit


class SearchCoordinator: Coordinator {
  
  private let service: MoviesServiceable
  let navigationController: UINavigationController
  
  init(service: MoviesServiceable) {
    self.service = service
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let searchViewModel = SearchViewModel(service: service)
    let searchViewController = SearchViewController(searchViewModel)
    
    navigationController.viewControllers = [searchViewController]
  }
  
  func showDetail() {}
  
}
