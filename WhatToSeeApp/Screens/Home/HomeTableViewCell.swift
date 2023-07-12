//
//  HomeTableViewCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
  
  //MARK: - Properties
  static let reuseId = "HomeTableViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "HomeTableViewCell", bundle: nil)
  }
  private let collectionView = UICollectionView()
  
  
  // MARK: -
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  
  //MARK: - Methods
  private func setupCollectionView() {
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
}


// MARK: - UICollectionViewDataSource
extension HomeTableViewCell: UICollectionViewDataSource {
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {
      return 10
    }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
    }
  
}


// MARK: - UICollectionViewDelegate
extension HomeTableViewCell: UICollectionViewDelegate {}
