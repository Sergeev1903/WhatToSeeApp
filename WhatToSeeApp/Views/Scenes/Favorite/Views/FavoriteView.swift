//
//  FavoriteView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 21.08.2023.
//

import UIKit


class FavoriteView: UIView {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  
  // MARK: - Coordinator
  private let coordinator: FavoriteCoordinator
  
  // MARK: - ViewModel
  private let viewModel: FavoriteViewModelProtocol
  
  
  // MARK: - Init
  init(frame: CGRect = .zero,
       coordinator: FavoriteCoordinator,
       viewModel: FavoriteViewModelProtocol) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(frame: frame)
    configureViewModel()
    setupCollectionView()
    trackingFavoriteState()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  private func setupCollectionView() {
    let layout = CollectionVerticalFlowLayout(
      itemsPerRow: 3, margin: 8, lineSpacing: 8,
      interitemSpacing: 8, heightMultiplier: 1.5)
    
    collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      CategoryCellItem.self,
      forCellWithReuseIdentifier: CategoryCellItem.reuseId)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: topAnchor),
      collectionView.leftAnchor.constraint(equalTo: leftAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
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
  
  // action for trackingFavoriteState
  @objc func handleNotification() {
    configureViewModel()
  }
  
}


// MARK: - UICollectionViewDataSource
extension FavoriteView: UICollectionViewDataSource {
  
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
extension FavoriteView: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      coordinator.showDetail(detailViewModel)
    }
  
}
