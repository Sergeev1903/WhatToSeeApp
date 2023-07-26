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
        collectionView.reloadData()
    }
  }
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCollectionView()
    contentViewGradient()
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    backgroundGradient.frame = CGRect(
      x: 0, y: 0,
      width: contentView.layer.bounds.width,
      height: contentView.layer.bounds.height)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: - Methods
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    
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
        equalTo: contentView.leadingAnchor, constant: 16),
      collectionView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor),
      collectionView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor)
    ])
  }
  
  private func contentViewGradient() {
    
    backgroundGradient.colors = [
      UIColor.systemBackground.cgColor,
      UIColor.darkGray.withAlphaComponent(0.5).cgColor
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
extension CategoryCell: UICollectionViewDelegate {}


// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryCell: UICollectionViewDelegateFlowLayout {
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 150, height: 225)
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 16
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return 16
    }
  
}
