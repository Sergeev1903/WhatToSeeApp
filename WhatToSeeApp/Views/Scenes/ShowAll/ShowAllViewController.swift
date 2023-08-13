//
//  ShowAllViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import UIKit


class ShowAllViewController: UIViewController {
  
  // MARK: - Properties
  private var collectionView: UICollectionView!
  
  // MARK: - ViewModel
  var viewModel: ShowAllViewModelProtocol!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = viewModel.category
    setupNavigationBar()
    setupCollectionView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
  }
  
  
  // MARK: - Methods
  private func setupNavigationBar() {
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
  
}


// MARK: - UICollectionViewDataSource
extension ShowAllViewController: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return viewModel.numberOfItemsInSection()
    }
  
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCellItem.reuseId, for: indexPath) as! CategoryCellItem
      cell.viewModel = viewModel.cellForItemAt(indexPath: indexPath)
      return cell
    }
  
}


// MARK: - UICollectionViewDelegate
extension ShowAllViewController: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      let vc = DetailViewController()
      vc.viewModel = detailViewModel
      navigationController?.pushViewController(vc, animated: true)
    }
  
  
  // MARK: - Load more movies
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
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

