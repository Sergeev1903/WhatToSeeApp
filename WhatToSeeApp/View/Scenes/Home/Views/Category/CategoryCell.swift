//
//  HomeTableViewCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit


class CategoryCell: UITableViewCell {
  
  // MARK: - Propererties
  static let reuseId = String(describing: CategoryCell.self)
  private var collectionView: UICollectionView!
  private let backgroundGradient = CAGradientLayer()
  
  // MARK: - View Model
  var viewModel: CategoryCellViewModelProtocol! {
    didSet {
      self.collectionView.reloadData()
    }
  }
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCollectionView()
    contentViewGradient()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: -
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundGradient.frame = CGRect(
      x: 0, y: 0,
      width: contentView.layer.bounds.width,
      height: contentView.layer.bounds.height)
  }
  
  
  // MARK: - Methods
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 150, height: 225)
    layout.scrollDirection = .horizontal
    layout.minimumInteritemSpacing = 16
    layout.minimumLineSpacing = 16
    layout.sectionInset.left = 16
    
    collectionView = UICollectionView(
      frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(
      CategoryCellItem.self,
      forCellWithReuseIdentifier: CategoryCellItem.reuseId)
    
    collectionView.backgroundColor = .clear
    contentView.addSubview(collectionView)
    
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(
        equalTo: contentView.topAnchor),
      collectionView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor),
      collectionView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func contentViewGradient() {
    backgroundGradient.colors = [
      UIColor.systemBackground.cgColor,
      UIColor.darkGray.withAlphaComponent(0.1).cgColor
    ]
    
    backgroundGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
    backgroundGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    contentView.layer.insertSublayer(backgroundGradient, at: 0)
  }
  
}


// MARK: - UICollectionViewDataSource
extension CategoryCell: UICollectionViewDataSource {
  
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
extension CategoryCell: UICollectionViewDelegate {
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      viewModel.delegate?.didTapCategoryCell(self, viewModel: detailViewModel)
    }
  
}


