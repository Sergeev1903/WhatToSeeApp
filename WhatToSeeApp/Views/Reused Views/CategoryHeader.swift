//
//  CategoryHeader.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 19.07.2023.
//

import UIKit


protocol CategoryHeaderButtonDelegate: AnyObject {
  func didTabCategoryHeaderButton(_ categoryHeader: CategoryHeader)
}


class CategoryHeader: UITableViewHeaderFooterView {
  
  // MARK: - Properties
  static let reuseId = String(describing: CategoryHeader.self)
  
  public let titleLabel = UILabel()
  private let button = UIButton(type: .system)
  
  // MARK: - Delegate
  weak var delegate: CategoryHeaderButtonDelegate?
  
  
  // MARK: - Init
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupTitle()
    setupButton()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  public func configure(title: String) {
    self.titleLabel.text = title
  }
  
  private func setupTitle() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.textColor = .label
    titleLabel.font = .boldSystemFont(ofSize: 22)
    
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
      self, action: #selector(categoryHeaderButtonAction),
      for: .touchUpInside)
    
    contentView.addSubview(button)
    
    NSLayoutConstraint.activate([
      button.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -20),
      button.centerYAnchor.constraint(
        equalTo: contentView.centerYAnchor)])
  }
  
  // category header button Action
  @objc private func categoryHeaderButtonAction() {
    delegate?.didTabCategoryHeaderButton(self)
  }
  
}
