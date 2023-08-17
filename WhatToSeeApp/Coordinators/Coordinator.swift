//
//  Coordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.08.2023.
//

import UIKit

protocol Coordinator: AnyObject {
  var navigationController: UINavigationController { get }
  func start()
}


extension Coordinator {
  
  var navigationController: UINavigationController {
    return  UINavigationController()
  }
  
}

