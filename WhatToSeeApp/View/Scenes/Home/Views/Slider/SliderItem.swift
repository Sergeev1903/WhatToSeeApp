//
//  PreviewSliderCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 18.07.2023.
//

import UIKit


class SliderItem: UICollectionViewCell {
  
  // MARK: Properties
  static let reuseId = String(describing: SliderItem.self)
  
  public let imageView = UIImageView()
  private let loadIndicator = UIActivityIndicatorView()
  private let topGradientView = UIView()
  private let topGradientLayer = CAGradientLayer()
  private let bottomGradientView = UIView()
  private let bottomGradientLayer = CAGradientLayer()
  
  
  // MARK: - ViewModel
  var viewModel: SliderItemViewModelProtocol! {
    didSet {
      loadIndicator.startAnimating()
      DispatchQueue.global(qos: .userInitiated).async {
        guard let data = self.viewModel.mediaData else {
          return
        }
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
    setupTopGradientView()
    setupBottomGradientView()
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
    loadIndicator.hidesWhenStopped = true
    loadIndicator.style = .large
    loadIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(loadIndicator)
    
    NSLayoutConstraint.activate([
      loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
  private func setupTopGradientView() {
    topGradientView.translatesAutoresizingMaskIntoConstraints = false
    topGradientView.backgroundColor = .clear
    
    imageView.addSubview(topGradientView)
    
    topGradientLayer.colors = [
      UIColor.systemBackground.cgColor,
      UIColor.clear.cgColor
    ]
    topGradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    topGradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
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
    bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
    bottomGradientView.backgroundColor = .clear
    
    imageView.addSubview(bottomGradientView)
    
    bottomGradientLayer.colors = [
      UIColor.systemBackground.cgColor,
      UIColor.clear.cgColor
    ]
    bottomGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    bottomGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
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
