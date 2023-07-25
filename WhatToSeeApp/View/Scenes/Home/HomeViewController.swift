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
  private let tableView = UITableView(frame: .zero, style: .plain)
  private let slider = Slider()
  
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol! {
    didSet {
      viewModel.getMovieCategories {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
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
      height: 560)
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
        withIdentifier: CategoryCell.reuseId, for: indexPath) as! CategoryCell
      
      switch indexPath.section {
      case 0:
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath, mediaItems: viewModel.nowPlayingMovies)
      case 1:
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath, mediaItems: viewModel.popularMovies)
      case 2:
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath, mediaItems: viewModel.topRatedMovies)
      case 3:
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath, mediaItems: viewModel.trendingMovies)
      default:
        break
      }
      
      return cell
    }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
      let headerView = tableView.dequeueReusableHeaderFooterView(
        withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
      
      switch section {
      case 0: headerView.configure(title: "Now Playing")
      case 1: headerView.configure(title: "Popular")
      case 2: headerView.configure(title: "Top Rated")
      case 3: headerView.configure(title: "Trending")
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
      return 250
    }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat {
      return 32
    }
  
}