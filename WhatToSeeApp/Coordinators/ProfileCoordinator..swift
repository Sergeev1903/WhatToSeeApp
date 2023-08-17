//
//  ProfileCoordinator..swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 14.08.2023.
//

import UIKit


class ProfileCoordinator: Coordinator {
  
  let navigationController: UINavigationController
  
  init() {
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let profileViewController = ProfileViewController()
    
    navigationController.viewControllers = [profileViewController]
  }

}
