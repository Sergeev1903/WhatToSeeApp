//
//  ViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

class HomeViewController: UIViewController {
  
  // MARK: - Properties
  private let customSegmentedControl = CustomSegmentedControl()
  private let tableView = UITableView(frame: .zero, style: .grouped)
  private let scrollView = UIScrollView()
  
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
      viewModel.getMedia(completion: {
        // #Debug
        print(self.viewModel.mediaItems.forEach({ media in
          print(media.title)
        }))
      })
    }
  }
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    viewModel = HomeViewModel()
    setupCustomSegmentedControl()
    setupNavigationBar()
    setupTableView()
  }
  
  
  // MARK: - Methods
  private func setupNavigationBar() {
    navigationController?.navigationBar.shadowImage = UIImage()
    
    let profileButton = createCustomBarButton(
      customImage: UIImage(named: "user")!,
      size: 32,
      selector: #selector(profileRightButtonTapped))
    
    navigationItem.rightBarButtonItems = [profileButton]
    navigationItem.titleView = customSegmentedControl
  }
  
  @objc private func profileRightButtonTapped() {
    let vc = ProfileViewController()
    present(vc, animated: true)
  }
  
  private func setupCustomSegmentedControl() {
    customSegmentedControl.frame = CGRect(
      x: 0, y: 0, width: self.view.frame.width, height: 40)
    customSegmentedControl.segments = ["Movies", "TV Shows"]
    customSegmentedControl.segmentTintColor = .clear
    customSegmentedControl.underlineColor = .systemBlue
    customSegmentedControl.underlineHeight = 2.0
    customSegmentedControl.addTarget(
      self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
  }
  
  @objc func segmentValueChanged(_ sender: CustomSegmentedControl) {
    print("#Debug Selected segment index: \(sender.selectedSegmentIndex)")
  }
  
  private func createTableHeaderView() -> UIView {
    let headerView = PreviewSliderView(
      frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 600))
    headerView.setImages(images: images)
    return headerView
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.tableHeaderView = createTableHeaderView()
    tableView.register(
      UITableViewCell.self, forCellReuseIdentifier: "cell")
    
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
    _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 20
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
      cell?.textLabel?.text = "\(indexPath.row)"
      return cell!
    }
  
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 40
    }
  
}

