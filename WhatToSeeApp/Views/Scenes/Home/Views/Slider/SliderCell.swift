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
  
  // MARK: - ViewModel
  var viewModel: SliderCellViewModelProtocol! {
    didSet {
      configureSliderCell()
    }
  }
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupLoadIndicator()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  private func setupImageView() {
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    layer.masksToBounds = true
    
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
  
  private func configureSliderCell() {
    var url: URL?
    
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: url = viewModel.mediaPosterURL
    case .pad: url = viewModel.mediaBackdropURL
    default: break
    }
    
    imageView.sd_setImage(
      with: url,
      placeholderImage: UIImage(named: "load_placeholder"),
      options: .delayPlaceholder) {[weak self] _,_,_,_ in
        
        guard let strongSelf = self else { return }
        
        strongSelf.loadIndicator.stopAnimating()
      }
  }
  
}

