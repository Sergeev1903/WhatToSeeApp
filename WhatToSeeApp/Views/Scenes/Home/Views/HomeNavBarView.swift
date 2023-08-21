//
//  HomeNavBarView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 21.08.2023.
//

import UIKit


class HomeNavBarView: UIView {
  
  // MARK: - Properties
  private(set) var profileButton = UIButton(type: .custom)
  private(set) var tabMenu = TabMenuControl()
  
  // MARK: - Coordinator
  private let coordinator: HomeCoordinator
  
  
  // MARK: - Init
  init(frame: CGRect = .zero,
       coordinator: HomeCoordinator) {
    self.coordinator = coordinator
    super.init(frame: frame)
    setupTabMenu()
    setupProfileButton()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  private func setupProfileButton() {
    profileButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let profileButtonImage = UIImage(named: "user")?
      .resized(to: CGSize(width: 32, height: 32))
    profileButton.setBackgroundImage(profileButtonImage, for: .normal)
    profileButton.addTarget(
      self, action: #selector(profileRightButtonTapped), for: .touchUpInside)
  }
  
  // Action for profile right button
  @objc private func profileRightButtonTapped() {
    coordinator.showProfile()
  }
  
  private func setupTabMenu() {
    tabMenu.frame = CGRect(
      x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
    tabMenu.segments = ["Movies", "TV Shows"]
    tabMenu.segmentTintColor = .clear
    tabMenu.underlineColor = .systemBlue
    tabMenu.underlineHeight = 4.0
    tabMenu.addTarget(
      self, action: #selector(tabMenuValueChanged(_:)), for: .valueChanged)
  }
  
  // Action for tabMenu
  @objc private func tabMenuValueChanged(_ sender: TabMenuControl) {
    if sender.selectedSegmentIndex == 1 {
      alert {
        sender.selectedSegmentIndex = 0
      }
    }
  }
  
  // Plug alert
  private func alert(completion: @escaping () -> Void) {
    let alert = UIAlertController(
      title: "Coming Soon",
      message: "Sorry! This section is under development",
      preferredStyle: .alert)
    let action = UIAlertAction(
      title: "Cancel", style: .destructive) {_ in
        completion()
      }
    alert.addAction(action)
    coordinator.navigationController.present(alert, animated: true)
  }
  
}
