//
//  WishListViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class FavoriteViewController: UIViewController {
  
  // MARK: - Properties
  private var favoriteView: FavoriteView!
  
  // MARK: - Coordinator
  weak var coordinator: FavoriteCoordinator?
  
  // MARK: - ViewModel
  private let viewModel: FavoriteViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: FavoriteViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Lifecycle
  override func loadView() {
    super.loadView()
    setupFavoriteView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favorites"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar(withLargeTitles: true)
  }
  
  
  // MARK: - Methods
  private func setupFavoriteView() {
    guard let coordinator = coordinator else {
      return
    }
    favoriteView = FavoriteView(coordinator: coordinator, viewModel: viewModel)
    view = favoriteView
  }
  
}
