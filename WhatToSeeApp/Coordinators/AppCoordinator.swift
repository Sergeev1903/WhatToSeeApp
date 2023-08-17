//
//  AppCoordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 07.08.2023.
//

import UIKit


class AppCoordinator: Coordinator {
  
  // MARK: - Properties
  private let window: UIWindow
  private let tabBarController: UITabBarController
  private let service: MoviesServiceable
  
  
  // MARK: - Init
  init(window: UIWindow) {
    self.window = window
    self.tabBarController = MainTabBarController()
    self.service = MoviesService()
  }
  
  
  // MARK: - Methods
  func start() {
    configureTabBar()
    window.rootViewController = tabBarController
    window.makeKeyAndVisible()
  }
  
  private func configureTabBar() {
    
    // Home
    let homeCoordinator = HomeCoordinator(service: service)
    let homeItem = createTabBarItem(
      homeCoordinator, titleName: "Home", imageName: "house")
    
    // Search
    let searchCoordinator = SearchCoordinator(service: service)
    let searchItem = createTabBarItem(
      searchCoordinator, titleName: "Search", imageName: "magnifyingglass")
    
    // Favorite
    let favoriteCoordinator = FavoriteCoordinator(service: service)
    let favoriteItem = createTabBarItem(
      favoriteCoordinator, titleName: "Favorite", imageName: "heart")
    
    // Profile
    let profileCoordinator = ProfileCoordinator()
    let profileItem = createTabBarItem(
      profileCoordinator, titleName: "Profile", imageName: "person.crop.circle")
    
    
    tabBarController.viewControllers = [
      homeItem, searchItem, favoriteItem, profileItem
    ]
    
  }
  
  
  private func createTabBarItem(
    _ coordiantor: Coordinator,
    titleName: String,
    imageName: String) -> UIViewController {
      
      let item = coordiantor.navigationController
      
      item.tabBarItem.title = titleName
      item.tabBarItem.image = UIImage(systemName: imageName)
      
      coordiantor.start()
      
      return item
    }
  
}

