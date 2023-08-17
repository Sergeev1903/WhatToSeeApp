//
//  CategoryItem.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 19.07.2023.
//

import UIKit
import SDWebImage


class CategoryCellItem: UICollectionViewCell {
  
  // MARK: - Properties
  static let reuseId = String(describing: CategoryCellItem.self)
  
  private let imageView = UIImageView()
  private let voteLabel = UILabel()
  private let loadIndicator = UIActivityIndicatorView()
  
  // MARK: - ViewModel
  var viewModel: CategoryCellItemViewModelProtocol! {
    didSet {
      configureCategoryCellItem()
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
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
    voteLabel.text = nil
    voteLabel.backgroundColor = .lightGray.withAlphaComponent(0.5)
    imageView.backgroundColor = .darkGray.withAlphaComponent(0.5)
  }
  
  
  private func setupImageView() {
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 10
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(imageView)
    
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor),
      imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
      imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func setupVoteLabel() {
    voteLabel.textAlignment = .center
    voteLabel.numberOfLines = 0
    voteLabel.font = .systemFont(ofSize: 12)
    voteLabel.isHidden = true
    voteLabel.translatesAutoresizingMaskIntoConstraints = false
    
    imageView.addSubview(voteLabel)
    
    voteLabel.layer.borderWidth = 1
    voteLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8014279801)
    voteLabel.layer.cornerRadius = 16
    voteLabel.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      voteLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: 4),
      voteLabel.topAnchor.constraint(
        equalTo: contentView.topAnchor, constant: 4),
      voteLabel.heightAnchor.constraint(
        equalToConstant: 32),
      voteLabel.widthAnchor.constraint(
        equalToConstant: 32)
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
  
  private func configureCategoryCellItem() {
    imageView.sd_setImage(
      with: viewModel.mediaPosterURL,
      placeholderImage: UIImage(named: "load_placeholder"),
      options: .delayPlaceholder) {_,_,_,_ in
        
        self.loadIndicator.stopAnimating()
        guard self.loadIndicator.isHidden == true else { return }
        self.voteLabel.isHidden = false
        self.voteLabel.text = self.viewModel.mediaVoteAverage
        self.voteLabel.backgroundColor =
        self.viewModel.mediaVoteCount <= 6 ?
        #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.8031870861): #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 0.8018936258)
      }
  }
  
}
