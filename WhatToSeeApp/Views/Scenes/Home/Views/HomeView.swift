//
//  HomeView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 20.08.2023.
//

import UIKit


class HomeView: UIView {
  
  // MARK: - Properties
  private(set) var tableView = UITableView(frame: .zero, style: .grouped)
  private(set) var tabMenu = TabMenuControl()
  private(set) var slider = SliderView()
  private(set) var profileButton = UIButton(type: .custom)

  // MARK: - Coordinator
  private var coordinator: HomeCoordinator
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol
  
  
  init(frame: CGRect = .zero, coordinator: HomeCoordinator, viewModel: HomeViewModelProtocol) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(frame: frame)
    backgroundColor = .systemBackground
    configureNavigationBar()
    setupTabMenu()
    setupTableView()
    configureViewModel()
  }
  
  required init?(coder: NSCoder) {
    return nil
  }
  
  // MARK: - Methods
  private func configureViewModel() {
    viewModel.getMovieCategories {
      self.tableView.reloadData()
    }
  }
  
  
  private func configureNavigationBar() {
    coordinator.navigationController.navigationItem.titleView = tabMenu
    
    // Custom favorite button
    coordinator.navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
  }
  
  
  private func setupProfileButton() {
    profileButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let image = UIImage(named: "user")!
    profileButton.setImage(image, for: .normal)
    profileButton.backgroundColor = .white.withAlphaComponent(0.7)
    profileButton.tintColor = .darkGray.withAlphaComponent(0.7)
    profileButton.layer.cornerRadius = profileButton.frame.height / 2
    profileButton.addTarget(
      self, action: #selector(profileRightButtonTapped), for: .touchUpInside)
  }

  
  // Action for profile right button
  @objc private func profileRightButtonTapped() {
    coordinator.showProfile()
  }
  
  
  private func setupTabMenu() {
    tabMenu.frame = CGRect(x: 0, y: 0, width: frame.width, height: 40)
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

  
  private func setupTableView() {
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(
      CategoryHeader.self,
      forHeaderFooterViewReuseIdentifier: CategoryHeader.reuseId)
    tableView.register(
      CategoryCell.self,
      forCellReuseIdentifier: CategoryCell.reuseId)
    tableView.register(
      CategoryGenresCell.self,
      forCellReuseIdentifier: CategoryGenresCell.reuseId)
    
    addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor, constant: -16),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  // Called in willDisplayHeaderView method
  func setupSlider() {
    slider.frame = CGRect(
      x: 0, y: 0, width: tableView.bounds.width, height: 600)
    slider.delegate = self
    
    slider.viewModel = SliderViewModel(
      mediaItems: viewModel.upcomingMovies)
    
    tableView.tableHeaderView = slider
  }
}

// MARK: - UITableViewDataSource
extension HomeView: UITableViewDataSource {
  
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
      
      switch indexPath.section {
        
      case 0:
        // NowPlaying
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.nowPlayingMovies)
        cell.delegate = self
        return cell
        
      case 1:
        // Genres
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryGenresCell.reuseId,
          for: indexPath) as! CategoryGenresCell
        return cell
        
      case 2:
        // Popular
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.popularMovies)
        cell.delegate = self
        return cell
        
      case 3:
        // TopRated
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.topRatedMovies)
        cell.delegate = self
        return cell
        
      case 4:
        // Trending
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.trendingMovies)
        cell.delegate = self
        return cell
        
      default: return UITableViewCell()
      }
    }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
      
      switch section {
        
      case 0:
        // NowPlaying
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.nowPlaying.rawValue)
        headerView.delegate = self
        return headerView
        
      case 2:
        // Popular
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.popular.rawValue)
        headerView.delegate = self
        return headerView
        
      case 3:
        // TopRated
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.topRated.rawValue)
        headerView.delegate = self
        return headerView
        
      case 4:
        // Trending
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.trending.rawValue)
        headerView.delegate = self
        return headerView
        
      default:  return UIView()
      }
    }
  
}


// MARK: - UITableViewDelegate
extension HomeView: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return indexPath.section == 1 ? 200: 258
    }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat {
      return section == 1 ? 0: 32
    }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      if indexPath.section == 1 {
        coordinator.showGenres()
      }
    }
  
  func tableView(
    _ tableView: UITableView,
    willDisplayHeaderView view: UIView,
    forSection section: Int) {
      setupSlider()
    }
  
}


// MARK: - CategoryCellDelegate
extension HomeView: CategoryCellDelegate {
  
  func didTapCategoryCell(
    _ categoryCell: CategoryCell, viewModel: DetailViewModelProtocol) {
      coordinator.showDetail(viewModel)
    }
  
}


// MARK: - SliderViewDelegate
extension HomeView: SliderViewDelegate {
  
  func didTapSliderView(
    _ sliderView: SliderView, viewModel: DetailViewModelProtocol) {
      coordinator.showDetail(viewModel)
    }
  
}


// MARK: - CategoryHeaderButtonDelegate
extension HomeView: CategoryHeaderButtonDelegate {
  
  func didTabCategoryHeaderButton(_ categoryHeader: CategoryHeader) {
    coordinator.showAll(from: categoryHeader, with: viewModel)
  }
  
}


// MARK: - NoInternetViewControllerDelegate
extension HomeView: NoInternetViewControllerDelegate {
  
  func reloadData(_ noInternetViewController: NoInternetViewController) {
    viewModel.getMovieCategories {
      self.tableView.reloadData()
    }
  }
  
}
