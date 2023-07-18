//
//  CategoryItem.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 19.07.2023.
//

import UIKit

class CategoryCellItem: UICollectionViewCell {
  
  // MARK: - Properties
  static let reuseId = String(describing: CategoryCellItem.self)
  
  let imageView = UIImageView()
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: -
  override func prepareForReuse() {
    imageView.image = nil
  }
  
  
  // MARK: - Methods
  private func setupImageView() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .red
    imageView.contentMode = .scaleAspectFit
    
    addSubview(imageView)
    layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

}
