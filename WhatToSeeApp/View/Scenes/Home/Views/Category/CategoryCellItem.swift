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
  private let voteLabel = UILabel()
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
      voteLabel.text = viewModel.mediaVoteAverage
//      voteLabel.layer.borderColor = viewModel.media.voteAverage ?? 0 <= 6 ?
//      #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1): #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 1)
      voteLabel.backgroundColor = viewModel.media.voteAverage ?? 0 <= 6 ?
      #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.8031870861): #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 0.8018936258)
    }
  }
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupVoteLabel()
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
    imageView.contentMode = .scaleAspectFill
    
    addSubview(imageView)
    
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  // FIXME: bug with size
  private func setupVoteLabel() {
    voteLabel.textAlignment = .center
    voteLabel.numberOfLines = 0
    voteLabel.font = UIFont.systemFont(ofSize: 12)
//    voteLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8019453642)
    voteLabel.translatesAutoresizingMaskIntoConstraints = false

    imageView.addSubview(voteLabel)
    
    voteLabel.layer.borderWidth = 1
    voteLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    voteLabel.layer.cornerRadius = 15
    voteLabel.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      voteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      voteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      voteLabel.heightAnchor.constraint(equalToConstant: 30),
      voteLabel.widthAnchor.constraint(equalToConstant: 30),

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
