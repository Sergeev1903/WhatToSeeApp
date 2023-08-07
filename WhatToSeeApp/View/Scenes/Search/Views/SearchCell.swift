//
//  SearchCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import UIKit

class SearchCell: UITableViewCell {
  
  // MARK: - Propererties
  static let reuseId = String(describing: SearchCell.self)
  
  private let containerView = UIView()
  private let mediaImageView = UIImageView()
  private let gradient = CAGradientLayer()
  private let mediaTitle = UILabel()
  private let mediaVoteLabel = UILabel()
  private let loadIndicator = UIActivityIndicatorView()
  
  
  // MARK: - ViewModel
  var viewModel: SearchCellViewModelProtocol! {
    didSet {
      configureSearchCell()
    }
  }
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupContainerView()
    setupMediaImageView()
    setupGradient()
    setupMediaTitle()
    setupMediaVoteLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.frame = mediaImageView.bounds
  }
  
  
  // MARK: - Methods
  private func setupContainerView() {
    backgroundColor = .clear
    selectionStyle = .none
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(containerView)
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(
        equalTo: contentView.topAnchor, constant: 8),
      containerView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: 8),
      containerView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor, constant: -8),
      containerView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -8)
    ])
  }
  
  private func setupMediaImageView() {
    mediaImageView.contentMode = .scaleAspectFill
    mediaImageView.layer.cornerRadius = 10
    mediaImageView.layer.masksToBounds = true
    mediaImageView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    containerView.addSubview(mediaImageView)
  }
  
  private func setupGradient() {
    mediaImageView.addGradientAddSublayer(
      gradient,
      colors: [.systemBackground.withAlphaComponent(0.5), .clear],
      startPoint: .bottom,
      endPoint: .top)
  }
  
  private func setupMediaTitle() {
    mediaTitle.numberOfLines = 0
    mediaTitle.textAlignment = .center
    mediaTitle.font = .boldSystemFont(ofSize: 18)
    mediaTitle.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(mediaTitle)
    
    NSLayoutConstraint.activate([
      mediaTitle.topAnchor.constraint(
        equalTo: containerView.centerYAnchor),
      mediaTitle.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor),
      mediaTitle.bottomAnchor.constraint(
        equalTo: containerView.bottomAnchor),
      mediaTitle.trailingAnchor.constraint(
        equalTo: containerView.trailingAnchor)
    ])
  }
  
  private func setupMediaVoteLabel() {
    mediaVoteLabel.textAlignment = .center
    mediaVoteLabel.numberOfLines = 0
    mediaVoteLabel.font = UIFont.systemFont(ofSize: 12)
    mediaVoteLabel.translatesAutoresizingMaskIntoConstraints = false
    
    containerView.addSubview(mediaVoteLabel)
    
    mediaVoteLabel.layer.borderWidth = 1
    mediaVoteLabel.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0.8014279801)
    mediaVoteLabel.layer.cornerRadius = 16
    mediaVoteLabel.layer.masksToBounds = true
    
    NSLayoutConstraint.activate([
      mediaVoteLabel.leadingAnchor.constraint(
        equalTo: containerView.leadingAnchor, constant: 4),
      mediaVoteLabel.topAnchor.constraint(
        equalTo: containerView.topAnchor, constant: 4),
      mediaVoteLabel.heightAnchor.constraint(
        equalToConstant: 32),
      mediaVoteLabel.widthAnchor.constraint(
        equalToConstant: 32)
    ])
  }
  
  
  private func setupLoadIndicator() {
    // TODO: -
  }
  
  private func configureSearchCell() {
    mediaTitle.text = viewModel.mediaTitleWithReleaseYear
    mediaImageView.sd_setImage(with: viewModel.mediaBackdropURL)
    
    mediaVoteLabel.text = viewModel.mediaVoteAverage
    mediaVoteLabel.backgroundColor = viewModel.media.voteAverage ?? 0 <= 6 ?
    #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 0.8031870861): #colorLiteral(red: 0.1960784314, green: 0.8431372549, blue: 0.2941176471, alpha: 0.8018936258)
  }
  
}
