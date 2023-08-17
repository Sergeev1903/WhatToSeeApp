//
//  ShowAllCoordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 17.08.2023.
//

import UIKit


class ShowAllCoordinator: Coordinator {
  
  // MARK: - Properties
  let navigationController: UINavigationController
  let viewModel: ShowAllViewModelProtocol
  
  
  // MARK: - Init
  init(navigationController: UINavigationController,
       viewModel: ShowAllViewModelProtocol) {
    self.navigationController = navigationController
    self.viewModel = viewModel
  }
  
  
  // MARK: - ShowAllCoordinator start
  func start() {
    let showAllViewController = ShowAllViewController(viewModel)
    showAllViewController.coordinator = self
    
    navigationController.pushViewController(showAllViewController, animated: true)
  }
  
}


extension ShowAllCoordinator {
  
  // DetailViewController
  func showDetail(_ viewModel: DetailViewModelProtocol) {
    let vc = DetailViewController(viewModel)
    navigationController.pushViewController(vc, animated: true)
  }
  
}
