//
//  ProfileCoordinator..swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 14.08.2023.
//

import UIKit


class ProfileCoordinator: Coordinator {
  
  // MARK: - Properties
  let navigationController: UINavigationController
  
  
  // MARK: - Init
  init() {
    self.navigationController = UINavigationController()
  }
  
  
  // MARK: - ProfileCoordinator start
  func start() {
    let profileViewController = ProfileViewController()
    
    navigationController.viewControllers = [profileViewController]
  }

}
