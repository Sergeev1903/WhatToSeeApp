//
//  ViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class HomeViewController: UIViewController {
  
  // MARK: - Properties
  private var homeView: HomeView!
  private var homeNavBar: HomeNavBarView!
  
  // MARK: - Coordinator
  weak var coordinator: HomeCoordinator?
  
  // MARK: - ViewModel
  private let viewModel: HomeViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: HomeViewModelProtocol) {
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
    setupHomeView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBarItems()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar(withLargeTitles: false)
  }
  
  
  // MARK: - Methods
  private func configureNavigationBarItems() {
    guard let coordinator = coordinator else {
      return
    }
    homeNavBar = HomeNavBarView(coordinator: coordinator)
    
    navigationItem.titleView = homeNavBar.tabMenu
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: homeNavBar.profileButton)
  }
  
  private func setupHomeView() {
    guard let coordinator = coordinator else {
      return
    }
    homeView = HomeView(coordinator: coordinator, viewModel: viewModel)
    view = homeView
  }
  
}


