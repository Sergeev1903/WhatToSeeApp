//
//  MainTabBarController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class MainTabBarController: UITabBarController {
  
  // MARK: - Properties
  var service: MoviesServiceable!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTabBarItem()
  }
  
  
  // MARK: - Methods
  private func configureTabBarItem() {
    
    service = MoviesService()
    
    let home = createTabBarItem(
      HomeViewController(HomeViewModel(service: service)),
      titleName: "Home",
      imageName: "house")
    
    
    let search = createTabBarItem(
      SearchViewController(SearchViewModel(service: service)),
      titleName: "Search",
      imageName: "magnifyingglass")
    
    let favorite = createTabBarItem(
      FavoriteViewController(FavoriteViewModel(service: service)),
      titleName: "Favorite",
      imageName: "heart")
    
    let profile = createTabBarItem(
      ProfileViewController(),
      titleName: "Profile",
      imageName: "person.crop.circle")
    
    viewControllers = [home, search, favorite, profile]
  }
  
  private func createTabBarItem(
    _ viewController: UIViewController,
    titleName: String,
    imageName: String) -> UIViewController {
      
      let navigationController = UINavigationController(
        rootViewController: viewController)
      
      navigationController.tabBarItem.title = titleName
      navigationController.tabBarItem.image = UIImage(systemName: imageName)
      
      return navigationController
    }
  
}


// MARK: - ViewControllerRepresentable
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
  
  typealias UIViewControllerType = MainTabBarController
  
  func makeUIViewController(context: Context) -> UIViewControllerType {
    MainTabBarController()
  }
  
  func updateUIViewController(
    _ uiViewController: UIViewControllerType, context: Context) {}
  
}

struct ViewController_Previews: PreviewProvider {
  
  static var previews: some View {
    ViewControllerRepresentable()
  }
  
}

