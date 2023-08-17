//
//  DetailViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 26.07.2023.
//

import UIKit


class DetailViewController: UIViewController {
  
  // MARK: - Properties
  private let tableView = UITableView()
  private let tableHeaderView = DetailHeaderView()
  private let backNavButton = UIButton(type: .custom)
  private let favoriteNavButton = UIButton(type: .custom)
  
  
  // MARK: - ViewModel
  var viewModel: DetailViewModelProtocol!
  
  
  // MARK: - Init
  init(_ viewModel: DetailViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.configureViewModel()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setuptTableView()
    setupHeaderView()
    setupBackNavButton()
    setupFavoriteNavButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }
  
  
  // MARK: - Methods
  
  private func setupNavigationBar() {
    // Make the Navigation Bar background transparent
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.tintColor = .white
    
    // Custom back button
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backNavButton)
    
    // Custom favorite button
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoriteNavButton)
  }
  
  
  private func setupBackNavButton() {
    backNavButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    let image = UIImage(systemName: "arrow.left")
    backNavButton.setImage(image, for: .normal)
    backNavButton.backgroundColor = .white.withAlphaComponent(0.7)
    backNavButton.tintColor = .darkGray.withAlphaComponent(0.7)
    backNavButton.layer.cornerRadius = backNavButton.frame.height / 2
    backNavButton.addTarget(
      self, action: #selector(backButtonTapped), for: .touchUpInside)
  }
  // custom back button action
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
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
      self, action: #selector(favoriteButtonTapped(_:) ), for: .touchUpInside)
  }
  // custom favorite button action
  @objc private func favoriteButtonTapped(_ sender: UIBarButtonItem) {
    
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
      hud.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      hud.topAnchor.constraint(equalTo: view.topAnchor, constant: 48)
    ])
  }
  
  private func setuptTableView() {
    tableView.frame = view.bounds
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    view.addSubview(tableView)
  }
  
  private func setupHeaderView() {
    tableHeaderView.frame = CGRect(
      x: 0, y: 0, width: self.view.bounds.width, height: 300)
    tableHeaderView.delegate = self
    tableView.tableHeaderView = tableHeaderView
  }
  
  private func configureHeaderView() {
    tableHeaderView.imageView.sd_setImage(with: viewModel.mediaBackdropURL)
    tableHeaderView.titleLabel.text = self.viewModel.mediaTitle
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
  
  private func configureViewModel() {
    viewModel.getMovieDetails {
      self.tableView.reloadData()
    }

    configureHeaderView()
  }
  
}


// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDataSource {
  
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
extension DetailViewController: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let headerView = self.tableView.tableHeaderView as! DetailHeaderView
    headerView.scrollViewDidScroll(scrollView: scrollView)
  }
  
}


// MARK: - WatchTrailerButtonDelegate
extension DetailViewController: WatchTrailerButtonDelegate {
  
  func didTabWatchTrailerButton(_ detailHeaderView: DetailHeaderView) {
    
    guard let trailerUrl = viewModel.detailTrailerUrl else {
      
      // FIXME: -
      detailHeaderView.watchTrailerButton.isEnabled = false
      showHUDView(with: "Sorry! \n No trailers")
      return
    }
    
    UIApplication.shared.open(trailerUrl)
  }
  
}
