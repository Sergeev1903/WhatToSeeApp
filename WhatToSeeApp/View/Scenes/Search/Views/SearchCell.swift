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
  
  private let mediaImageView = UIImageView()
  private let mediaTitle = UILabel()
  private let loadIndicator = UIActivityIndicatorView()
  
  
  // MARK: - ViewModel
  var viewModel: SearchCellViewModelProtocol! {
    didSet {
      // TODO: -
    }
  }
  
  
  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    print("Sorry! only code, no storyboards")
  }
  
  
  // MARK: - Methods
  private func setupMediaImageView() {
    // TODO: -
  }
  
  private func setupMediaTitle() {
    // TODO: -
  }
  
  private func setupLoadIndicator() {
    // TODO: -
  }
  
}
