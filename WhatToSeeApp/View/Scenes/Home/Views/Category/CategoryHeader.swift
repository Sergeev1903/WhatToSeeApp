//
//  CategoryHeader.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 19.07.2023.
//

import UIKit


class CategoryHeader: UITableViewHeaderFooterView {

  // MARK: - Properties
  static let reuseId = String(describing: CategoryHeader.self)
  private let titleLabel = UILabel()
  private let button = UIButton(type: .system)
  
  
  // MARK: - Init
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: - Methods
  func configure(title: String) {
    self.titleLabel.text = title
  }
  
  private func configureUI() {
    setupTitle()
    setupButton()
  }
  
  private func setupTitle() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .label
    titleLabel.font = UIFont.systemFont(ofSize: 24)
    
    contentView.addSubview(titleLabel)
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: 16),
      titleLabel.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor)])
  }
  
  private func setupButton() {
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("See All", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.addTarget(
      self, action: #selector(headerDidTapped),
      for: .touchUpInside)
    
    contentView.addSubview(button)

    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -20),
      button.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor)])
  }
  
  // MARK: -
  @objc func headerDidTapped() {
  }

}
