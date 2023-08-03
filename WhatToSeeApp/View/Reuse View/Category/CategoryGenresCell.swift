//
//  MovieGenreTableViewCell.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 31.07.2023.
//

import UIKit


class CategoryGenresCell: UITableViewCell {
  
  // MARK: - Properties
  static let reuseId = String(describing: CategoryGenresCell.self)
  
  private let backgroundImageView = UIImageView()
  private let titleLabel = UILabel()
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundImageViewSetup()
    setupTitleLabel()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: - Methods
  private func backgroundImageViewSetup() {
    backgroundColor = .clear
    selectionStyle = .none
    
    backgroundImageView.image = UIImage(named: "movie_genre_cell")
    
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: backgroundImageView.contentMode = .scaleAspectFill
    case .pad: backgroundImageView.contentMode = .top
    default: break
    }
    
    backgroundImageView.layer.cornerRadius = 10
    backgroundImageView.layer.masksToBounds = true
    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(backgroundImageView)
    
    NSLayoutConstraint.activate([
      backgroundImageView.topAnchor.constraint(
        equalTo: contentView.topAnchor ),
      backgroundImageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: 8),
      backgroundImageView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor),
      backgroundImageView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -8)
    ])
    
    let colorView = UIView()
    colorView.backgroundColor = UIColor(
      hue: 0.6, saturation: 0.6, brightness: 0.6, alpha: 0.7)
    colorView.translatesAutoresizingMaskIntoConstraints = false
    
    backgroundImageView.addSubview(colorView)
    
    NSLayoutConstraint.activate([
      colorView.topAnchor.constraint(
        equalTo: backgroundImageView.topAnchor ),
      colorView.leadingAnchor.constraint(
        equalTo: backgroundImageView.leadingAnchor),
      colorView.bottomAnchor.constraint(
        equalTo: backgroundImageView.bottomAnchor),
      colorView.trailingAnchor.constraint(
        equalTo: backgroundImageView.trailingAnchor)
    ])
  }
  
  private func setupTitleLabel() {
    titleLabel.text = MovieCategory.genres.rawValue
    titleLabel.font = UIFont.boldSystemFont(ofSize: 100)
    titleLabel.numberOfLines = 0
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor(
      patternImage: backgroundImageView.image!)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    backgroundImageView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(
        equalTo: backgroundImageView.topAnchor ),
      titleLabel.leadingAnchor.constraint(
        equalTo: backgroundImageView.leadingAnchor, constant: 8),
      titleLabel.bottomAnchor.constraint(
        equalTo: backgroundImageView.bottomAnchor),
      titleLabel.trailingAnchor.constraint(
        equalTo: backgroundImageView.trailingAnchor, constant: -8)
    ])
  }
  
}
