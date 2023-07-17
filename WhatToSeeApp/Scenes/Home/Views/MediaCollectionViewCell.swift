//
//  MediaCollectionViewCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import UIKit

class MediaCollectionViewCell: UICollectionViewCell {
    
  // MARK: - Properties
  static let reuseId = "MediaCollectionViewCell"
  static func nib() -> UINib {
    return UINib(nibName: "MediaCollectionViewCell", bundle: nil)
  }
  private let posterImageView = UIImageView()
  
  
  // MARK: - Methods
  private func setupPosterImageView() {}
  
}
