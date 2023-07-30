//
//  CustomFlowlayout.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 30.07.2023.
//

import UIKit

final class CustomVerticalFlowLayout: UICollectionViewFlowLayout {
  
  // MARK: - Properties
  private var itemsPerRow: CGFloat = 2
  private var margin: CGFloat = 8
  private var lineSpacing: CGFloat = 8
  private var interitemSpacing: CGFloat = 8
  private var heightMultiplier: CGFloat = 1.5
  
  // MARK: - Initializers
  init(itemsPerRow: CGFloat, margin: CGFloat, lineSpacing: CGFloat,
       interitemSpacing: CGFloat, heightMultiplier: CGFloat) {
    self.itemsPerRow = itemsPerRow
    self.margin = margin
    self.lineSpacing = lineSpacing
    self.interitemSpacing = interitemSpacing
    self.heightMultiplier = heightMultiplier
    super.init()
    
    sectionInsetReference = .fromSafeArea
  }

  override init() {
    super.init()
    sectionInsetReference = .fromSafeArea
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  // MARK: - Lifecycle
  override func prepare() {
    super.prepare()
    // MARK: Calculate items size
    let screenWidth = self.collectionView?.bounds.width
    let availableWidth = (screenWidth ?? 0) -
    interitemSpacing * (itemsPerRow + 1)
    let finalWidth = availableWidth / itemsPerRow
    let finalHeight = finalWidth * heightMultiplier
    
    self.itemSize = CGSize(width: finalWidth, height: finalHeight)
    self.sectionInset = UIEdgeInsets(top: margin, left: margin,
                                     bottom: margin, right: margin)
    self.minimumLineSpacing = lineSpacing
    self.minimumInteritemSpacing = interitemSpacing
  }
  
}

