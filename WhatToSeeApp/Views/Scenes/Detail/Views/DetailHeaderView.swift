//
//  DetailHeaderView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 27.07.2023.
//

import UIKit


protocol WatchTrailerButtonDelegate: AnyObject {
  func didTabWatchTrailerButton(_ detailHeaderView: DetailHeaderView)
}


class DetailHeaderView: UIView {
  
  // MARK: - Properties
  public let imageView = UIImageView()
  public let titleLabel = UILabel()
  public let watchTrailerButton = UIButton()
  private let containerView = UIView()
  private let imageViewGradient = CAGradientLayer()
  private let containerViewGradient = CAGradientLayer()
  private var containerViewHeight = NSLayoutConstraint()
  private var imageViewHeight = NSLayoutConstraint()
  private var imageViewBottom = NSLayoutConstraint()
  
  // MARK: - Delegate
  weak var delegate: WatchTrailerButtonDelegate?
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    createViews()
    setViewConstraints()
    setupWatchTrailerButton()
    setupTitleLabel()
  }
  
  required init?(coder aDecoder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: -
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    setupImageViewGradient()
    setupContainerViewGradient()
  }
  
  
  // MARK: - Methods
  // Stretchy header
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    containerViewHeight.constant = scrollView.contentInset.top
    let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
    containerView.clipsToBounds = offsetY <= 0
    imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
    imageViewHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
  }
  
  private func setupWatchTrailerButton() {
    let imageConfig = UIImage.SymbolConfiguration(weight: .thin)
    let buttonImage = UIImage(
      systemName: "play.circle", withConfiguration: imageConfig)
    
    watchTrailerButton.setBackgroundImage(buttonImage, for: .normal)
    watchTrailerButton.tintColor = .white.withAlphaComponent(0.7)
    watchTrailerButton.translatesAutoresizingMaskIntoConstraints = false
    
    watchTrailerButton.addTarget(
      self, action: #selector(watchTrailerButtonAction), for: .touchUpInside)
    
    containerView.addSubview(watchTrailerButton)
    
    NSLayoutConstraint.activate([
      watchTrailerButton.heightAnchor.constraint(
        equalToConstant: 100),
      watchTrailerButton.widthAnchor.constraint(
        equalToConstant: 100),
      watchTrailerButton.centerXAnchor.constraint(
        equalTo: containerView.centerXAnchor),
      watchTrailerButton.centerYAnchor.constraint(
        equalTo: containerView.centerYAnchor, constant: -50)
    ])
    
  }
  
  @objc private func watchTrailerButtonAction() {
    delegate?.didTabWatchTrailerButton(self)
  }
  
  private func setupTitleLabel() {
    titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
    titleLabel.textAlignment = .center
    titleLabel.numberOfLines = 0
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(titleLabel)
    
    // FIXME: - NSLayoutConstraint error in console
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: containerView.centerYAnchor, constant: 8),
      titleLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor, constant: 8),
      titleLabel.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor, constant: -8),
      titleLabel.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor, constant: -8),
    ])
  }
  
  private func createViews() {
    self.addSubview(containerView)
    
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
    
    // ContainerView Constraints
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
  
  private func setupImageViewGradient() {
    imageView.addGradientAddSublayer(
      imageViewGradient,
      colors: [.black.withAlphaComponent(0.2), .clear, .clear],
      startPoint: .top, endPoint: .bottom,
      locations: [0, 0.5, 1])
  }
  
  private func setupContainerViewGradient() {
    containerView.addGradientInsertSublayer(
      containerViewGradient, at: 1,
      colors: [.black, .clear],
      startPoint: .bottom, endPoint: .top)
  }
  
}

