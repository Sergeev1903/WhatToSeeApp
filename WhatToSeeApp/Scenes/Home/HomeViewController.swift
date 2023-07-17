//
//  ViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  private let tagMenuSegmentedControl = TagMenuSegmentedControl()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  
  var images = [
    UIImage(named: "1")!, UIImage(named: "2")!,
    UIImage(named: "3")!, UIImage(named: "4")!,
    UIImage(named: "5")!, UIImage(named: "6")!,
    UIImage(named: "7")!, UIImage(named: "8")!,
    UIImage(named: "9")!, UIImage(named: "10")!,
    UIImage(named: "11")!
  ]
  
  // MARK: - ViewModel
  private var viewModel: HomeViewModelProtocol! {
    didSet {
      viewModel.getMedia {
        self.tableView.reloadData()
      }
    }
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    viewModel = HomeViewModel(service: MoviesService())
    setupTagMenuSegmentedControl()
    setupNavigationBar()
    setupTableView()
  }
  
  
  // MARK: - Methods
  private func setupNavigationBar() {
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let profileButton = createCustomBarButton(
      image: UIImage(named: "user")!,
      size: 32,
      selector: #selector(profileRightButtonTapped))
    
    navigationItem.rightBarButtonItems = [profileButton]
    navigationItem.titleView = tagMenuSegmentedControl
  }
  
  @objc private func profileRightButtonTapped() {
    let vc = ProfileViewController()
    present(vc, animated: true)
  }
  
  private func setupTagMenuSegmentedControl() {
    tagMenuSegmentedControl.frame = CGRect(
      x: 0, y: 0,
      width: self.view.frame.width, height: 40)
    tagMenuSegmentedControl.segments = ["Movies", "TV Shows"]
    tagMenuSegmentedControl.segmentTintColor = .clear
    tagMenuSegmentedControl.underlineColor = .systemBlue
    tagMenuSegmentedControl.underlineHeight = 2.0
    tagMenuSegmentedControl.addTarget(
      self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
  }
  
  @objc func segmentValueChanged(_ sender: TagMenuSegmentedControl) {
    print("#Debug Selected segment index: \(sender.selectedSegmentIndex)")
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(
      UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.register(
      PreviewSliderView.self,
      forHeaderFooterViewReuseIdentifier: PreviewSliderView.reuseId)
    
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(
        equalTo: view.topAnchor),
      tableView.leftAnchor.constraint(
        equalTo: view.leftAnchor),
      tableView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(
        equalTo: view.bottomAnchor)
    ])
  }
  
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      viewModel.mediaItems.count
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      cell?.textLabel?.text = viewModel.mediaItems[indexPath.row].title
      return cell!
    }
  
  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
      print("header start")
      let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: PreviewSliderView.reuseId) as! PreviewSliderView
      header.setImages(images: viewModel.mediaImages)
      print("header end")
      return header
    }
  
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 40
    }
  
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int) -> CGFloat {
      return 600
    }
  
}
