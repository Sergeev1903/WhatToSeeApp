//
//  ViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  private let tabMenu = TabMenu()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let slider = Slider()
  
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol! {
    didSet {
      viewModel.getMedia {
        self.tableView.reloadData()
      }
    }
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    viewModel = HomeViewModel(service: MoviesService())
    setupTabMenu()
    setupNavigationBar()
    setupTableView()
    setupSlider()
  }
  
  
  // MARK: - Methods
  private func setupNavigationBar() {
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationItem.titleView = tabMenu
    
    let profileButton = createCustomBarButton(
      image: UIImage(named: "user")!,
      size: 32,
      selector: #selector(profileRightButtonTapped))
    
    navigationItem.rightBarButtonItems = [profileButton]
  }
  
  // Action for profile right button
  @objc private func profileRightButtonTapped() {
    let vc = ProfileViewController()
    present(vc, animated: true)
  }
  
  private func setupTabMenu() {
    tabMenu.frame = CGRect(
      x: 0, y: 0,
      width: self.view.frame.width,
      height: 40)
    tabMenu.segments = ["Movies", "TV Shows"]
    tabMenu.segmentTintColor = .clear
    tabMenu.underlineColor = .systemBlue
    tabMenu.underlineHeight = 2.0
    tabMenu.addTarget(
      self, action: #selector(tabMenuValueChanged(_:)), for: .valueChanged)
  }
  
  // Action for tabMenu
  @objc func tabMenuValueChanged(_ sender: TabMenu) {
    print("#Debug Selected segment index: \(sender.selectedSegmentIndex)")
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(
      UITableViewCell.self, forCellReuseIdentifier: "cell")
    
    view.addSubview(tableView)
    
    tableView.tableHeaderView = slider
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(
        equalTo: view.topAnchor),
      tableView.leftAnchor.constraint(
        equalTo: view.leftAnchor),
      tableView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupSlider() {
    slider.frame = CGRect(
      x: 0, y: 0, width: tableView.bounds.width,
      height: 600)
  }
  
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      viewModel.mediaItems.count
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      cell?.textLabel?.text = viewModel.mediaItems[indexPath.row].title
      return cell!
    }
  
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80
    }
  
}
