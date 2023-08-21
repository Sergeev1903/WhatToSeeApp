//
//  DetailViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import UIKit


class DetailViewController: UIViewController {
  
  // MARK: - Properties
  private var detailView: DetailView!
  
  // MARK: - ViewModel
  private let viewModel: DetailViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: DetailViewModelProtocol) {
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
    setupDetailView()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBarItems()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar(withTransparent: true)
  }
  
  
  // MARK: - Methods
  private func configureNavigationBarItems() {
    // Custom back button
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      customView: detailView.backNavButton)
    
    detailView.backNavButton.addTarget(
      self, action: #selector(backButtonTapped), for: .touchUpInside)
    
    // Custom favorite button
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      customView: detailView.favoriteNavButton)
  }
  
  // custom back button action
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  private func setupDetailView() {
    detailView = DetailView(viewModel: viewModel)
    view = detailView
  }
  
}
