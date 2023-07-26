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
      viewModel.getMovieCategories {
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
    
    let profileButton = createBarButton(
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
    tabMenu.underlineHeight = 4.0
    tabMenu.addTarget(
      self, action: #selector(tabMenuValueChanged(_:)), for: .valueChanged)
  }
  
  // Action for tabMenu
  @objc func tabMenuValueChanged(_ sender: TabMenu) {
    print("#Debug Selected segment index: \(sender.selectedSegmentIndex)")
    
    if sender.selectedSegmentIndex == 1 {
      alert {
        sender.selectedSegmentIndex = 0
      }
    }
    
  }
  
  
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
    present(alert, animated: true)
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.register(
      CategoryHeader.self,
      forHeaderFooterViewReuseIdentifier: CategoryHeader.reuseId)
    tableView.register(
      CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseId)
    
    tableView.tableHeaderView = slider
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(
        equalTo: view.topAnchor, constant: -16),
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
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections()
  }
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfRowsInSection()
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CategoryCell.reuseId,
        for: indexPath) as! CategoryCell
      
      switch indexPath.section {
      case 0:
        cell.configure(mediaItems: viewModel.nowPlayingMovies)
      case 1:
        cell.configure(mediaItems: viewModel.popularMovies)
      case 2:
        cell.configure(mediaItems: viewModel.topRatedMovies)
      case 3:
        cell.configure(mediaItems: viewModel.trendingMovies)
      default: break
      }

      return cell
    }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
      let headerView = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
      
      switch section {
      case 0: headerView.configure(title: MovieCategory.nowPlaying.rawValue )
      case 1: headerView.configure(title: MovieCategory.popular.rawValue)
      case 2: headerView.configure(title: MovieCategory.topRated.rawValue)
      case 3: headerView.configure(title: MovieCategory.trending.rawValue)
      default: break
      }
      
      return headerView
    }
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 258
    }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat {
      return 42
    }
  
}
