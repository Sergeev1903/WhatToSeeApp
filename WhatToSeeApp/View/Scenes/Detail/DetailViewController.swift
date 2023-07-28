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
  
  // MARK: - View Model
  var viewModel: DetailViewModel! {
    didSet {
      DispatchQueue.global(qos: .utility).async {
        guard let data = self.viewModel.mediaImageData else { return }
        let image = UIImage(data: data)
        
        DispatchQueue.main.async {
          self.headerView.imageView.image = image
          self.headerView.titleLabel.text = self.viewModel.mediaTitle
        }
      }
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

      // Remove 'Back' text and Title from Navigation Bar
      self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
      self.title = ""
  }

  
  // MARK: - Methods
  private func setuptTableView() {
    tableView.delegate = self
    tableView.dataSource = self
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
        cell.textLabel?.text = viewModel.mediaVoteAverage
      case 1:
        cell.textLabel?.text = viewModel.mediaReleaseDate
      case 2:
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
