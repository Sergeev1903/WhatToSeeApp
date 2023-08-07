//
//  SearchViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


class SearchViewController: UIViewController {
  
  // MARK: - Properties
  private let searchController = UISearchController()
  private let tableView = UITableView()
  private var timer = Timer()
  
  // MARK: - ViewModel
  private var viewModel: SearchViewModelProtocol!

  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Search"
    setupViewModel()
    setupNavigationBar()
    setupSearchbar()
    setupTableView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupNavigationBar()
  }
  
  
  // MARK: - Methods
  private func setupViewModel() {
    viewModel = SearchViewModel(service: MoviesService())
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
  }
  
  private func setupSearchbar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Movies"
    navigationItem.searchController = searchController
    definesPresentationContext = true
  }
  
  private func setupTableView() {
    tableView.frame = view.bounds
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.register(
      SearchCell.self, forCellReuseIdentifier: SearchCell.reuseId)
    
    view.addSubview(tableView)
  }
  
}


// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
  
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfRowsInSection()
    }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(
        withIdentifier: SearchCell.reuseId, for: indexPath) as! SearchCell
      
      cell.viewModel = viewModel.cellForRowAt(indexPath: indexPath)
      return cell
    }
  
}


// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 200
    }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      let vc = DetailViewController()
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      vc.viewModel = detailViewModel
      navigationController?.pushViewController(vc, animated: true)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  
}


// MARK: - UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text,
          !searchText.isEmpty else {
      return
    }
    timer.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                 repeats: false, block: { [weak self] _ in
      guard let self else { return }
      viewModel.searchMovies(searchText: searchText, page: 1) {
        self.tableView.reloadData()
      }
    })
  }
  
}
