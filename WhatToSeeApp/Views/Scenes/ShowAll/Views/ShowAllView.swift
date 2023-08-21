//
//  ShowAllView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 21.08.2023.
//

import UIKit


class ShowAllView: UIView {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  
  // MARK: - Coordinator
  private let coordinator: ShowAllCoordinator
  
  // MARK: - ViewModel
  private let viewModel: ShowAllViewModelProtocol
  
  
  // MARK: - Init
  init(frame: CGRect = .zero, coordinator: ShowAllCoordinator, viewModel: ShowAllViewModelProtocol) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(frame: frame)
    setupCollectionView()
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
  
}


// MARK: - UICollectionViewDataSource
extension ShowAllView: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return viewModel.numberOfItemsInSection()
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: CategoryCellItem.reuseId, for: indexPath) as! CategoryCellItem
      cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
      return cell
    }
  
}


// MARK: - UICollectionViewDelegate
extension ShowAllView: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      coordinator.showDetail(detailViewModel)
    }
  
  
  // MARK: - Load more movies
  func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      
      //     Load more movies when reaching the last item
      if indexPath.item == viewModel.numberOfItemsInSection()
          - 1 && viewModel.currentPage <= viewModel.totalPages {
        viewModel.currentPage += 1
        viewModel.loadMoreItems {
          self.collectionView.reloadData()
        }
      }
    }
  
}
