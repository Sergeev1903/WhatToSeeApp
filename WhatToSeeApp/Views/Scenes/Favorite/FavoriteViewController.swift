//
//  WishListViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class FavoriteViewController: UIViewController {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  
  // MARK: - Coordinator
  var coordinator: FavoriteCoordinator?
  
  // MARK: - ViewModel
  var viewModel: FavoriteViewModelProtocol
  
  
  // MARK: - Init
  init(_ viewModel: FavoriteViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Favorites"
    setupCollectionView()
    configureViewModel()
    trackingFavoriteState()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }
  
  
  // MARK: - Methods
  private func setupNavigationBar() {
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func setupCollectionView() {
    let layout = CollectionVerticalFlowLayout(
      itemsPerRow: 3, margin: 8, lineSpacing: 8,
      interitemSpacing: 8, heightMultiplier: 1.5)
    
    collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    collectionView.frame = view.bounds
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      CategoryCellItem.self,
      forCellWithReuseIdentifier: CategoryCellItem.reuseId)
    
    view.addSubview(collectionView)
  }
  
  private func configureViewModel() {
    viewModel.getFavoriteMovies {
      self.collectionView.reloadData()
    }
  }
  
  private func trackingFavoriteState() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(handleNotification),
      name: Notification.Name("UpdateFavorite"), object: nil)
  }
  
}


// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return viewModel.numberOfItemsInSection()
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CategoryCellItem.reuseId,
        for: indexPath) as! CategoryCellItem
      cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
      return cell
    }
  
}


// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      coordinator?.showDetail(detailViewModel)
    }
  
}


// MARK: -
extension FavoriteViewController {
  
  @objc func handleNotification() {
    configureViewModel()
  }
  
}
