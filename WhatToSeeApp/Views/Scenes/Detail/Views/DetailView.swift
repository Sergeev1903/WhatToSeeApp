//
//  DetailView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 21.08.2023.
//

import UIKit


class DetailView: UIView {
  
  // MARK: - Properties
  private let tableView = UITableView()
  private let tableHeaderView = DetailHeaderView()
  private(set) var backNavButton = UIButton(type: .custom)
  private(set) var favoriteNavButton = UIButton(type: .custom)
  
  // MARK: - ViewModel
  private let viewModel: DetailViewModelProtocol
  
  
  // MARK: - Init
  init(frame: CGRect = .zero, viewModel: DetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(frame: frame)
    configureViewModel()
    setuptTableView()
    setupHeaderView()
    setupBackNavButton()
    setupFavoriteNavButton()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  private func setuptTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  private func setupHeaderView() {
    tableHeaderView.frame = CGRect(
      x: 0, y: 0, width: tableView.bounds.width, height: 300)
    tableHeaderView.delegate = self
    tableView.tableHeaderView = tableHeaderView
  }
  
  private func configureHeaderView() {
    tableHeaderView.imageView.sd_setImage(with: viewModel.mediaBackdropURL)
    tableHeaderView.titleLabel.text = self.viewModel.mediaTitle
  }
  
  private func configureViewModel() {
    viewModel.getMovieDetails {
      self.tableView.reloadData()
    }
    
    configureHeaderView()
  }
  
  private func setupBackNavButton() {
    backNavButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let image = UIImage(systemName: "arrow.left")
    backNavButton.setImage(image, for: .normal)
    backNavButton.backgroundColor = .white.withAlphaComponent(0.7)
    backNavButton.tintColor = .darkGray.withAlphaComponent(0.7)
    backNavButton.layer.cornerRadius = backNavButton.frame.height / 2
  }
  
  private func setupFavoriteNavButton() {
    favoriteNavButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let image = UIImage(systemName: "heart.fill")
    favoriteNavButton.setImage(image, for: .normal)
    favoriteNavButton.backgroundColor = .white.withAlphaComponent(0.7)
    
    switch viewModel.isFavorite {
    case true:
      favoriteNavButton.tintColor = .red.withAlphaComponent(0.7)
    case false:
      favoriteNavButton.tintColor = .darkGray.withAlphaComponent(0.7)
    }
    
    favoriteNavButton.layer.cornerRadius = favoriteNavButton.frame.height / 2
    favoriteNavButton.addTarget(
      self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
  }
  // custom favorite button action
  @objc private func favoriteButtonTapped() {
    
    switch viewModel.isFavorite {
    case true:
      viewModel.removeFromFovorite {
        self.changeFavoriteState()
      }
    case false:
      viewModel.addToFovorite {
        self.changeFavoriteState()
      }
    }
    
  }
  
  private func showHUDView(with message: String) {
    let hud = HUDView()
    hud.showHUD(with: message, andIsHideToTop: true)
    hud.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hud.centerXAnchor.constraint(equalTo: centerXAnchor),
      hud.topAnchor.constraint(equalTo: topAnchor, constant: 54)
    ])
  }
  
  private func changeFavoriteState() {
    showHUDView(with: viewModel.favoriteStatusMessage)
    
    NotificationCenter.default.post(
      name: Notification.Name("UpdateFavorite"), object: nil)
    
    switch viewModel.isFavorite {
    case true:
      favoriteNavButton.tintColor = .red.withAlphaComponent(0.7)
    case false:
      favoriteNavButton.tintColor = .darkGray.withAlphaComponent(0.7)
    }
  }
  
}


// MARK: - UITableViewDelegate
extension DetailView: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return 4
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: "Cell", for: indexPath)
      
      cell.selectionStyle = .none
      cell.textLabel?.numberOfLines = 0
      cell.textLabel?.textAlignment = .left
      
      switch indexPath.row {
      case 0:
        cell.textLabel?.text = viewModel.detailGenres
      case 1:
        cell.textLabel?.text = viewModel.mediaVoteAverage
      case 2:
        cell.textLabel?.text = viewModel.mediaReleaseDate
      case 3:
        cell.textLabel?.text = viewModel.mediaOverview
      default:
        break
      }
      
      return cell
    }
  
}


// MARK: - UITableViewDelegate
extension DetailView: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let headerView = self.tableView.tableHeaderView as! DetailHeaderView
    headerView.scrollViewDidScroll(scrollView: scrollView)
  }
  
}


// MARK: - WatchTrailerButtonDelegate
extension DetailView: WatchTrailerButtonDelegate {
  
  func didTabWatchTrailerButton(_ detailHeaderView: DetailHeaderView) {
    
    guard let trailerUrl = viewModel.detailTrailerUrl else {
      return
    }
    
    UIApplication.shared.open(trailerUrl)
  }
  
}

