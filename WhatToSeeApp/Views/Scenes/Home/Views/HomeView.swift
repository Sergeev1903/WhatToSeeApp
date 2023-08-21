//
//  HomeView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 20.08.2023.
//

import UIKit


class HomeView: UIView {
  
  // MARK: - Properties
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let slider = SliderView()
  
  // MARK: - Coordinator
  private let coordinator: HomeCoordinator
  
  // MARK: - ViewModel
  private let viewModel: HomeViewModelProtocol
  
  
  // MARK: - Init
  init(frame: CGRect = .zero,
       coordinator: HomeCoordinator,
       viewModel: HomeViewModelProtocol) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(frame: frame)
    configureViewModel()
    setupHomeView()
    setupTableView()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  private func configureViewModel() {
    viewModel.getMovieCategories {
      self.tableView.reloadData()
    }
  }
  
  private func setupHomeView() {
    backgroundColor = .systemBackground
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
  private func setupSlider() {
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
        
      default:
        return UIView()
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
