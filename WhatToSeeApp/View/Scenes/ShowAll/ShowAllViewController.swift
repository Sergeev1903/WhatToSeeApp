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
  
  // MARK: - View Model
  var viewModel: ShowAllViewModelProtocol!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = viewModel.title
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
    let layout = CustomVerticalFlowLayout(
      itemsPerRow: 3, margin: 8, lineSpacing: 8,
      interitemSpacing: 8, heightMultiplier: 1.5)
    
    collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    collectionView.register(
      CategoryCellItem.self,
      forCellWithReuseIdentifier: CategoryCellItem.reuseId)
    
    view.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: view.topAnchor),
      collectionView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      collectionView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor)
    ])
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
}

