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
  private let imageView = UIImageView()
  private let loadIndicator = UIActivityIndicatorView()
  
  
  // MARK: - ViewModel
  var viewModel: CategoryCellItemViewModelProtocol! {
    didSet {
      loadIndicator.startAnimating()
      DispatchQueue.global(qos: .utility).async {
        guard let data = self.viewModel.mediaImageData else { return }
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {
          self.imageView.image = image
          self.loadIndicator.stopAnimating()
        }
      }
    }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupLoadIndicator()
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
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    
    addSubview(imageView)
    layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setupLoadIndicator() {
    loadIndicator.hidesWhenStopped = true
    loadIndicator.style = .large
    loadIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(loadIndicator)
    
    NSLayoutConstraint.activate([
      loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
}
