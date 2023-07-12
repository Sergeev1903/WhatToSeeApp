//
//  MainTabBarController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBarItem()
    setupAppearance()
  }
  
  
  // MARK: - Setup methods
  private func setupTabBarItem() {
    viewControllers = [
      createTabBarItem(
        HomeViewController(),
        titleName: "Home",
        imageName: "house"),
      createTabBarItem(SearchViewController(),
                       titleName: "Search",
                       imageName: "magnifyingglass"),
      createTabBarItem(WishListViewController(),
                       titleName: "Wishlist",
                       imageName: "bookmark"),
      createTabBarItem(ProfileViewController(),
                       titleName: "Profile",
                       imageName: "person.crop.circle")
    ]
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
  
  
  // MARK: - Appearance methods
  private func setupAppearance() {
    UITabBar.appearance().backgroundColor = .systemBackground
  }
}


// MARK: - ViewControllerRepresentable
import SwiftUI

struct ViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = MainTabBarController
  func makeUIViewController(
    context: Context) -> MainTabBarController {
      MainTabBarController()
    }
  
  func updateUIViewController(
    _ uiViewController: MainTabBarController,
    context: Context) {
    }
}

struct ViewController_Previews: PreviewProvider {
  static var previews: some View {
    ViewControllerRepresentable()
  }
}
