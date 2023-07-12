//
//  ParallaxView.swift
//  ParallaxDemo
//
//  Created by Алексей Пархоменко on 29/04/2019.
//  Copyright © 2019 Алексей Пархоменко. All rights reserved.
//

import UIKit

class ParallaxView: UIView {
  
  // MARK: - Properties
  static  let reuseId = "ParallaxView"
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let topGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.systemBackground.cgColor,
                            UIColor.clear.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    return gradientLayer
  }()
  
  let topGradientView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    return view
  }()
  
  let bottomGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [UIColor.clear.cgColor,
                            UIColor.systemBackground.cgColor]
    gradientLayer.locations = [0.0, 1.0]
    return gradientLayer
  }()
  
  let bottomGradientView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .clear
    return view
  }()
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupTopGradientView()
    setupBottomGradientView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // MARK: -
  override func layoutSubviews() {
    super.layoutSubviews()
    topGradientLayer.frame = CGRect(
      x: 0, y: -2,
      width: bounds.width,
      height: 60)

    bottomGradientLayer.frame = CGRect(
      x: 0, y: 0,
      width: bounds.width,
      height: 60)
  }
  
  
  // MARK: - Methods
  private func setupImageView() {
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
