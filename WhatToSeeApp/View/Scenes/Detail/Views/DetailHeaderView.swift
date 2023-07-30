//
//  DetailHeaderView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 27.07.2023.
//

import UIKit

protocol watchTrailerButtonDelegate: AnyObject {
  func didTabWatchTrailerButton(_ detailHeaderView: DetailHeaderView)
}


class DetailHeaderView: UIView {
  
  // MARK: - Properties
  var containerViewHeight = NSLayoutConstraint()
  var imageViewHeight = NSLayoutConstraint()
  var imageViewBottom = NSLayoutConstraint()
  
  var containerView = UIView()
  var imageView = UIImageView()
  var titleLabel = UILabel()
  let watchTrailerButton = UIButton()
  private let bottomGradientLayer = CAGradientLayer()
  
  // MARK: - Delegate
  weak var watchTrailerButtonDelegate: watchTrailerButtonDelegate?
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    createViews()
    setViewConstraints()
    setupWatchTrailerButton()
    setupTitleLabel()
    setupBottomGradientView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
  // MARK: -
  override func layoutSubviews() {
    super.layoutSubviews()
    bottomGradientLayer.frame = containerView.bounds
  }
  
  
  // MARK: - Methods
  private func setupWatchTrailerButton() {
    let imageConfig = UIImage.SymbolConfiguration(weight: .thin)
    let buttonImage = UIImage(
      systemName: "play.circle", withConfiguration: imageConfig)
    
    watchTrailerButton.setBackgroundImage(buttonImage, for: .normal)
    watchTrailerButton.tintColor = .white.withAlphaComponent(0.4)
    watchTrailerButton.translatesAutoresizingMaskIntoConstraints = false
    
    watchTrailerButton.addTarget(
      self, action: #selector(watchTrailerButtonAction), for: .touchUpInside)
    
    containerView.addSubview(watchTrailerButton)
    
    NSLayoutConstraint.activate([
      watchTrailerButton.heightAnchor.constraint(
        equalToConstant: 200),
      watchTrailerButton.widthAnchor.constraint(
        equalToConstant: 200),
      watchTrailerButton.centerXAnchor.constraint(
        equalTo: containerView.centerXAnchor),
      watchTrailerButton.centerYAnchor.constraint(
        equalTo: containerView.centerYAnchor)
    ])
    
  }
  
  @objc func watchTrailerButtonAction() {
    print("watchTrailerButtonAction")
    watchTrailerButtonDelegate?.didTabWatchTrailerButton(self)
  }
  
  private func setupTitleLabel() {
    titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor),
      titleLabel.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor, constant: -32),
      titleLabel.widthAnchor.constraint(
        equalTo: containerView.widthAnchor)
    ])
  }
  
  private func createViews() {
    // Container View
    self.addSubview(containerView)
    
    // ImageView for background
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    containerView.addSubview(imageView)
  }
  
  private func setViewConstraints() {
    // UIView Constraints
    NSLayoutConstraint.activate([
      self.widthAnchor.constraint(equalTo: containerView.widthAnchor),
      self.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
      self.heightAnchor.constraint(equalTo: containerView.heightAnchor)
    ])
    
    // Container View Constraints
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.widthAnchor.constraint(
      equalTo: imageView.widthAnchor).isActive = true
    containerViewHeight = containerView.heightAnchor.constraint(
      equalTo: self.heightAnchor)
    containerViewHeight.isActive = true
    
    // ImageView Constraints
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageViewBottom = imageView.bottomAnchor.constraint(
      equalTo: containerView.bottomAnchor)
    imageViewBottom.isActive = true
    imageViewHeight = imageView.heightAnchor.constraint(
      equalTo: containerView.heightAnchor)
    imageViewHeight.isActive = true
  }
  
  
  private func setupBottomGradientView() {
    bottomGradientLayer.colors = [
      UIColor.systemBackground.cgColor,
      UIColor.clear.cgColor
    ]
    bottomGradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
    bottomGradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
    
    containerView.layer.insertSublayer(bottomGradientLayer, at: 1)
  }
  
  
  // Stretchy header
  func scrollViewDidScroll(scrollView: UIScrollView) {
    containerViewHeight.constant = scrollView.contentInset.top
    let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
    containerView.clipsToBounds = offsetY <= 0
    imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
    imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
  }
  
}

