//
//  ProfileViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

class ProfileViewController: UIViewController {
  
  // MARK: - Properties
  let profileImageView = UIImageView()

  
  // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      title = "Profile"
      view.backgroundColor = .systemBackground
      
      setupNavigationBar()
      setupProfileImageView()
    }


  // MARK: - Methods
  
  // MARK: Setup NavigationBar
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: Setup ProfileImageView
  private func setupProfileImageView() {
    profileImageView.image = UIImage(named: "user")
    profileImageView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(profileImageView)
    
    NSLayoutConstraint.activate([
      profileImageView.heightAnchor.constraint(
        equalToConstant: 256),
      profileImageView.widthAnchor.constraint(
        equalToConstant: 256),
      profileImageView.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      profileImageView.centerYAnchor.constraint(
        equalTo: view.centerYAnchor)
    ])
  }
  
}
