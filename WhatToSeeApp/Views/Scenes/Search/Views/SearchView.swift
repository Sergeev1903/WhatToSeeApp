//
//  SearchView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 20.08.2023.
//

import UIKit


class SearchView: UIView {
  
  // MARK: - Properties
  private let tableView = UITableView()
  private(set) var searchController = UISearchController()
  private(set) var timer = Timer()
  
  // MARK: - Coordinator
  private let coordinator: SearchCoordinator
  
  // MARK: - ViewModel
  private let viewModel: SearchViewModelProtocol
  
  
  // MARK: - Init
  init(frame: CGRect = .zero,
       coordinator: SearchCoordinator,
       viewModel: SearchViewModelProtocol) {
    self.coordinator = coordinator
    self.viewModel = viewModel
    super.init(frame: frame)
    setupSearchbar()
    setupTableView()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Methods
  private func setupSearchbar() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search Movies"
    searchController.searchBar.text = "Terminator" // plug start text
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.separatorStyle = .none
    tableView.register(
      SearchCell.self, forCellReuseIdentifier: SearchCell.reuseId)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: topAnchor),
      tableView.leftAnchor.constraint(equalTo: leftAnchor),
      tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
      tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
}


// MARK: - UITableViewDataSource
extension SearchView: UITableViewDataSource {
  
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
extension SearchView: UITableViewDelegate {
  
  func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 200
    }
  
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      let detailViewModel = viewModel.didSelectItemAt(indexPath: indexPath)
      coordinator.showDetail(detailViewModel)
      
      tableView.deselectRow(at: indexPath, animated: true)
    }
  
}


// MARK: - UISearchResultsUpdating
extension SearchView: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchText = searchController.searchBar.text,
          !searchText.isEmpty else {
      return
    }
    timer.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                 repeats: false, block: { [weak self] _ in
      guard let strongSelf = self else {
        return
      }
      strongSelf.viewModel.searchMovies(searchText: searchText, page: 1) {
        strongSelf.tableView.reloadData()
      }
    })
  }
  
}
