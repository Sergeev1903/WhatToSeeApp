//
//  PreviewSliderCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit
import SDWebImage


class SliderCell: UICollectionViewCell {
  
  // MARK: Properties
  static let reuseId = String(describing: SliderCell.self)
  
  public let imageView = UIImageView()
  private let loadIndicator = UIActivityIndicatorView()
  private let gradientLayer = CAGradientLayer()
  
  // MARK: - ViewModel
  var viewModel: SliderCellViewModelProtocol! {
    didSet {
      imageView.sd_setImage(
        with: viewModel.mediaPosterURL,
        placeholderImage: UIImage(named: "load_placeholder"),
        options: .delayPlaceholder) { _,_,_,_ in
          self.loadIndicator.stopAnimating()
        }
    }
  }
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupLoadIndicator()
    setupGradientLayer()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: -
  override func prepareForReuse() {
    imageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradientLayer.frame = imageView.bounds
  }
  
  
  // MARK: - Methods
  private func setupImageView() {
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
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
    loadIndicator.startAnimating()
    loadIndicator.hidesWhenStopped = true
    loadIndicator.style = .large
    loadIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(loadIndicator)
    
    NSLayoutConstraint.activate([
      loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func setupGradientLayer() {
    gradientLayer.colors = [UIColor.systemBackground.cgColor,
                            UIColor.clear.cgColor,
                            UIColor.clear.cgColor,
                            UIColor.clear.cgColor,
                            UIColor.systemBackground.cgColor]
    // from top to bottom
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
    gradientLayer.locations = [0.0, 0.2, 0.5, 0.8, 1.0]
    
    imageView.layer.addSublayer(gradientLayer)
  }
  
}

