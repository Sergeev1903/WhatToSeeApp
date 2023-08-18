//
//  ViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit
import SDWebImage


class HomeViewController: UIViewController {
  
  // MARK: - Properties
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let tabMenu = TabMenuControl()
  private let slider = SliderView()
  
  // MARK: - Coordinator
  var coordinator: HomeCoordinator?
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: HomeViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.configureViewModel()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Deinit
  deinit {
    SDImageCache.shared.clearMemory()
    SDImageCache.shared.clearDisk()
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabMenu()
    setupTableView()
    configureNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }
  
  
  // MARK: - Methods
  private func configureViewModel() {
    viewModel.getMovieCategories {
      self.tableView.reloadData()
    }
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  private func configureNavigationBar() {
    navigationItem.titleView = tabMenu
    
    let profileButton = createBarButton(
      image: UIImage(named: "user")!,
      size: 32,
      selector: #selector(profileRightButtonTapped))
    
    navigationItem.rightBarButtonItems = [profileButton]
  }
  
  // Action for profile right button
  @objc private func profileRightButtonTapped() {
    coordinator?.showProfile()
  }
  
  private func setupTabMenu() {
    tabMenu.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 40)
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
    present(alert, animated: true)
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
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: -16),
      tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
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
extension HomeViewController: UITableViewDelegate {
  
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
        coordinator?.showGenres()
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
extension HomeViewController: CategoryCellDelegate {
  
  func didTapCategoryCell(
    _ categoryCell: CategoryCell, viewModel: DetailViewModelProtocol) {
      coordinator?.showDetail(viewModel)
    }
  
}


// MARK: - SliderViewDelegate
extension HomeViewController: SliderViewDelegate {
  
  func didTapSliderView(
    _ sliderView: SliderView, viewModel: DetailViewModelProtocol) {
      coordinator?.showDetail(viewModel)
    }
  
}


// MARK: - CategoryHeaderButtonDelegate
extension HomeViewController: CategoryHeaderButtonDelegate {
  
  func didTabCategoryHeaderButton(_ categoryHeader: CategoryHeader) {
    coordinator?.showAll(from: categoryHeader, with: viewModel)
  }
  
}


// MARK: - NoInternetViewControllerDelegate
extension HomeViewController: NoInternetViewControllerDelegate {
  
  func reloadData(_ noInternetViewController: NoInternetViewController) {
    viewModel.getMovieCategories {
      self.tableView.reloadData()
    }
  }
  
}
