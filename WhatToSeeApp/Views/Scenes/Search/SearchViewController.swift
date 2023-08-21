//
//  SearchViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class SearchViewController: UIViewController {
  
  // MARK: - Properties
  private(set) var searchView: SearchView!
  
  // MARK: - Coordinator
  weak var coordinator: SearchCoordinator?
  
  // MARK: - ViewModel
  private let viewModel: SearchViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: SearchViewModelProtocol) {
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
    setupSearchView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search"
    configureNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar(withLargeTitles: true)
  }
  
  
  // MARK: - Methods
  private func configureNavigationBar() {
    navigationItem.searchController = searchView.searchController
    definesPresentationContext = true
  }
  
  private func setupSearchView() {
    guard let coordinator = coordinator else {
      return
    }
    searchView = SearchView(coordinator: coordinator, viewModel: viewModel)
    view = searchView
  }
  
}

