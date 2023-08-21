//
//  ShowAllViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import UIKit


class ShowAllViewController: UIViewController {
  
  // MARK: - Properties
  private var showAllView: ShowAllView!
  
  // MARK: - Coordinator
  weak var coordinator: ShowAllCoordinator?
  
  // MARK: - ViewModel
  private let viewModel: ShowAllViewModelProtocol
  
  // MARK: - Init
  init(_ viewModel: ShowAllViewModelProtocol) {
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
    setupShowAllView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = viewModel.category
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar(withLargeTitles: true)
  }
  
  
  // MARK: - Methods
  private func setupShowAllView() {
    guard let coordinator = coordinator else {
      return
    }
    showAllView = ShowAllView(coordinator: coordinator, viewModel: viewModel)
    view = showAllView
  }
  
}

