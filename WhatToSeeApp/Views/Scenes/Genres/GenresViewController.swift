//
//  GenresViewController.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 01.08.2023.
//

import UIKit

class GenresViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    title = "Genres coming soon..."
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  deinit {
    print("GenresViewController deinit")
  }
  
}
