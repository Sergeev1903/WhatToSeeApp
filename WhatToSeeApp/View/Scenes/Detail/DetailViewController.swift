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
  private let headerView = DetailHeaderView()
  
  // MARK: - ViewModel
  var viewModel: DetailViewModelProtocol!{
    didSet {
      
      //      viewModel.getMultiplyRequest {
      //        self.tableView.reloadData()
      //      }
      
      viewModel.getMovieGenres {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
      
      viewModel.getMovieTrailers {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
      
      headerView.imageView.sd_setImage(with: viewModel.mediaBackdropURL)
      headerView.titleLabel.text = self.viewModel.mediaTitle
    }
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setuptTableView()
    setupHeaderView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Make the Navigation Bar background transparent
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.isTranslucent = true
    self.navigationController?.navigationBar.tintColor = .white
    
    // Create a custom back button
    let backButtonImage = UIImage(systemName: "arrow.backward.circle.fill")?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8), renderingMode: .alwaysOriginal)
    
    let buttonSize = CGSize(width: 32, height: 32)
    UIGraphicsBeginImageContextWithOptions(buttonSize, false, 0.0)
    backButtonImage?.draw(in: CGRect(origin: .zero, size: buttonSize))
    
    let resizedButtonImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    
    let backButton = UIBarButtonItem(image: resizedButtonImage, style: .plain, target: self, action: #selector(backButtonTapped))
    
    navigationItem.leftBarButtonItem = backButton
    
    
    // Create a custom wish button
    let wishButtonImage = UIImage(systemName: "heart.circle.fill")?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8), renderingMode: .alwaysTemplate)
    let wishButtonSize = CGSize(width: 32, height: 32)
    
    UIGraphicsBeginImageContextWithOptions(wishButtonSize, false, UIScreen.main.scale)
    wishButtonImage?.draw(in: CGRect(origin: .zero, size: wishButtonSize))
    
    let wishResizedButtonImage = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
    UIGraphicsEndImageContext()
    
    let wishButton = UIBarButtonItem(image: wishResizedButtonImage, style: .plain, target: self, action: #selector(wishButtonTapped))
    
    navigationItem.rightBarButtonItems = [wishButton]
    
  }
  
  
  // MARK: - Methods
  
  // custom back button action
  @objc private func backButtonTapped() {
    navigationController?.popViewController(animated: true)
  }
  
  // custom wish button action
  @objc private func wishButtonTapped() {
    print("wishButtonTapped")
        showHUD()
//    showHUDView()
    
  }
  
  private func showHUD() {
    let hudVC = HUDViewController()
    hudVC.modalPresentationStyle = .overFullScreen
    hudVC.modalTransitionStyle = .crossDissolve
    hudVC.showHUDAndHideToTop(withText: "Add to collection")
    present(hudVC, animated: true, completion: nil)
  }
  
  private func showHUDView() {
    let hud = HUDView()
    hud.showHUDAndHideToTop(with: "Add to collection")
    hud.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hud.heightAnchor.constraint(equalToConstant: 40),
      hud.widthAnchor.constraint(equalToConstant: 180),
      hud.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      hud.topAnchor.constraint(equalTo: view.topAnchor, constant: 48)
    ])
  }
  
  
  private func setuptTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorStyle = .none
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func setupHeaderView() {
    headerView.frame = CGRect(
      x: 0, y: 0,
      width: self.view.bounds.width,
      height: 500)
    headerView.watchTrailerButtonDelegate = self
    tableView.tableHeaderView = headerView
  }
  
}


// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return 10
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
      case 4:
        cell.textLabel?.text = viewModel.detailTrailerUrl
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
    UIApplication.shared.open(
      URL(string: viewModel.detailTrailerUrl)!,
      options: [:],
      completionHandler: nil)
  }
  
}
