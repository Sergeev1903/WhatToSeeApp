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
  private let tabMenu = TabMenuControl()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let slider = SliderView()
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol! {
    didSet {
      viewModel.getMovieCategories {
        self.tableView.reloadData()
      }
    }
  }
  
  
  // MARK: -
  deinit {
    SDImageCache.shared.clearMemory()
    SDImageCache.shared.clearDisk()
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setupViewModel()
    setupNavigationBar()
    setupTabMenu()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.prefersLargeTitles = false
  }
  
  
  // MARK: - Methods
  private func setupViewModel() {
    viewModel = HomeViewModel(service: MoviesService())
  }
  
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
    tabMenu.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40)
    tabMenu.segments = ["Movies", "TV Shows"]
    tabMenu.segmentTintColor = .clear
    tabMenu.underlineColor = .systemBlue
    tabMenu.underlineHeight = 4.0
    tabMenu.addTarget(
      self, action: #selector(tabMenuValueChanged(_:)), for: .valueChanged)
  }
  
  // Action for tabMenu
  @objc private func tabMenuValueChanged(_ sender: TabMenuControl) {
    print("#Debug Selected segment index: \(sender.selectedSegmentIndex)")
    
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
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.separatorStyle = .none
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
  
  // called in willDisplayHeaderView method
  private func setupSlider() {
    slider.frame = CGRect(
      x: 0, y: 0, width: tableView.bounds.width, height: 600)
    
    tableView.tableHeaderView = slider
    
    slider.viewModel = SliderViewModel(
      mediaItems: viewModel.upcomingMovies,delegate: self)
    
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
        cell.viewModel.delegate = self
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
        cell.viewModel.delegate = self
        return cell
        
      case 3:
        // TopRated
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.topRatedMovies)
        cell.viewModel.delegate = self
        return cell
        
      case 4:
        // Trending
        let cell = tableView.dequeueReusableCell(
          withIdentifier: CategoryCell.reuseId,
          for: indexPath) as! CategoryCell
        cell.viewModel = viewModel.cellForRowAt(
          indexPath: indexPath,
          mediaItems: viewModel.trendingMovies)
        cell.viewModel.delegate = self
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
        headerView.categoryHeaderButtonDelegate = self
        return headerView
        
      case 2:
        // Popular
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.popular.rawValue)
        headerView.categoryHeaderButtonDelegate = self
        return headerView
        
      case 3:
        // TopRated
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.topRated.rawValue)
        headerView.categoryHeaderButtonDelegate = self
        return headerView
        
      case 4:
        // Trending
        let headerView = tableView.dequeueReusableHeaderFooterView(
          withIdentifier: CategoryHeader.reuseId) as! CategoryHeader
        headerView.configure(title: MovieCategory.trending.rawValue)
        headerView.categoryHeaderButtonDelegate = self
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
      let vc = GenresViewController()
      navigationController?.pushViewController(vc, animated: true)
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
      let vc = DetailViewController()
      vc.viewModel = viewModel as? DetailViewModel
      navigationController?.pushViewController(vc, animated: true)
    }
  
}


// MARK: - SliderViewDelegate
extension HomeViewController: SliderViewDelegate {
  
  func didTapSliderView(
    _ categoryCell: SliderView, viewModel: DetailViewModelProtocol) {
      let vc = DetailViewController()
      vc.viewModel = viewModel as? DetailViewModel
      navigationController?.pushViewController(vc, animated: true)
    }
  
}


// MARK: - CategoryHeaderButtonDelegate
extension HomeViewController: CategoryHeaderButtonDelegate {
  
  func didTabcategoryHeaderButton(_ categoryHeader: CategoryHeader) {
    print("didTabcategoryHeaderButton")
    let vc = ShowAllViewController()
    
    switch categoryHeader.titleLabel.text {
      
    case MovieCategory.nowPlaying.rawValue:
      vc.viewModel = viewModel.didTapSeeAll(
        mediaItems: viewModel.nowPlayingMovies,
        category: MovieCategory.nowPlaying)
      
    case MovieCategory.popular.rawValue:
      vc.viewModel = viewModel.didTapSeeAll(
        mediaItems: viewModel.popularMovies,
        category: MovieCategory.popular)
      
    case MovieCategory.topRated.rawValue:
      vc.viewModel = viewModel.didTapSeeAll(
        mediaItems: viewModel.topRatedMovies,
        category: MovieCategory.topRated)
      
    case MovieCategory.trending.rawValue:
      vc.viewModel = viewModel.didTapSeeAll(
        mediaItems: viewModel.trendingMovies,
        category: MovieCategory.trending)
      
    default: break
    }
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
}
