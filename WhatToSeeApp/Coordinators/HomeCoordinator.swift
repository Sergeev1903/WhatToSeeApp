//
//  HomeCoordinator.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 13.08.2023.
//

import UIKit


class HomeCoordinator: Coordinator {
  
  // MARK: - Properties
  private let service: MoviesServiceable
  let navigationController: UINavigationController
  
  
  // MARK: - Init
  init(service: MoviesServiceable) {
    self.service = service
    self.navigationController = UINavigationController()
  }
  
  
  // MARK: - HomeCoordinator start
  func start() {
    let homeViewModel = HomeViewModel(service: service)
    let homeViewController = HomeViewController(homeViewModel)
    homeViewController.coordinator = self
    
    navigationController.viewControllers = [homeViewController]
  }
  
}


extension HomeCoordinator {
  
  // GenresViewController
  func showGenres() {
    let vc = GenresViewController()
    navigationController.pushViewController(vc, animated: true)
  }
  
  // ProfileViewController
  func showProfile() {
    let vc = ProfileViewController()
    navigationController.present(vc, animated: true)
  }
  
  // DetailViewController
  func showDetail(_ viewModel: DetailViewModelProtocol) {
    let vc = DetailViewController()
    vc.viewModel = viewModel as? DetailViewModel
    navigationController.pushViewController(vc, animated: true)
  }
  
  // ShowAllViewController
  func showAll(
    from categoryHeader: CategoryHeader, with viewModel: HomeViewModelProtocol) {
      
      let vc = ShowAllViewController()
      
      switch categoryHeader.titleLabel.text {
        
      case MovieCategory.nowPlaying.rawValue:
        vc.viewModel = viewModel.didTapSeeAllButton(
          mediaItems: viewModel.nowPlayingMovies,
          category: MovieCategory.nowPlaying)
        
      case MovieCategory.popular.rawValue:
        vc.viewModel = viewModel.didTapSeeAllButton(
          mediaItems: viewModel.popularMovies,
          category: MovieCategory.popular)
        
      case MovieCategory.topRated.rawValue:
        vc.viewModel = viewModel.didTapSeeAllButton(
          mediaItems: viewModel.topRatedMovies,
          category: MovieCategory.topRated)
        
      case MovieCategory.trending.rawValue:
        vc.viewModel = viewModel.didTapSeeAllButton(
          mediaItems: viewModel.trendingMovies,
          category: MovieCategory.trending)
        
      default: break
      }
      
      navigationController.pushViewController(vc, animated: true)
    }
  
}


