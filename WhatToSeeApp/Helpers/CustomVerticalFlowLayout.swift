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
  
  
  // MARK: - Init
  init(itemsPerRow: CGFloat, margin: CGFloat, lineSpacing: CGFloat,
       interitemSpacing: CGFloat, heightMultiplier: CGFloat) {
    
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: self.itemsPerRow = itemsPerRow
    case .pad: self.itemsPerRow = itemsPerRow + 2
    default: break
    }

    self.margin = margin
    self.lineSpacing = lineSpacing
    self.interitemSpacing = interitemSpacing
    self.heightMultiplier = heightMultiplier
    super.init()
    
    sectionInsetReference = .fromSafeArea
    self.scrollDirection = .vertical
  }

  override init() {
    super.init()
    sectionInsetReference = .fromSafeArea
    self.scrollDirection = .vertical
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.scrollDirection = .vertical
  }
  
  
  // MARK: - Methods
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

