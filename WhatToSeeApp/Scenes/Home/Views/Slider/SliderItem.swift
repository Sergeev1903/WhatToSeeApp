//
//  PreviewSliderCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit

class SliderItem: UICollectionViewCell {
    
  // MARK: Properties
  static let reuseId = "SliderItem"
  
  let imageView = UIImageView()
  
  let topGradientView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    return view
  }()
  
  let topGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.systemBackground.cgColor,
                            UIColor.clear.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    return gradientLayer
  }()
  
  let bottomGradientView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    return view
  }()
  
  let bottomGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.systemBackground.cgColor,
                            UIColor.clear.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    return gradientLayer
  }()
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupTopGradientView()
    setupBottomGradientView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupImageView()
  }
  
  // MARK: -
  override func layoutSubviews() {
    super.layoutSubviews()
    topGradientLayer.frame = CGRect(
      x: 0, y: 0,
      width: bounds.width,
      height: 60)

    bottomGradientLayer.frame = CGRect(
      x: 0, y: 0,
      width: bounds.width,
      height: 60)
  }
  
  // MARK: - Methods
  func configureSliderItem(with image: UIImage) {
    self.imageView.image = image
  }
  
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
  
  private func setupTopGradientView() {
    imageView.addSubview(topGradientView)
    topGradientView.layer.addSublayer(topGradientLayer)
    
    NSLayoutConstraint.activate([
      topGradientView.heightAnchor.constraint(
        equalToConstant: 60),
      topGradientView.topAnchor.constraint(
        equalTo: imageView.topAnchor),
      topGradientView.leadingAnchor.constraint(
        equalTo: imageView.leadingAnchor),
      topGradientView.trailingAnchor.constraint(
        equalTo: imageView.trailingAnchor)
    ])
  }
  
  private func setupBottomGradientView() {
    imageView.addSubview(bottomGradientView)
    bottomGradientView.layer.addSublayer(bottomGradientLayer)
    
    NSLayoutConstraint.activate([
      bottomGradientView.heightAnchor.constraint(
        equalToConstant: 60),
      bottomGradientView.leadingAnchor.constraint(
        equalTo: imageView.leadingAnchor),
      bottomGradientView.trailingAnchor.constraint(
        equalTo: imageView.trailingAnchor),
      bottomGradientView.bottomAnchor.constraint(
        equalTo: imageView.bottomAnchor)
    ])
  }
  
}

