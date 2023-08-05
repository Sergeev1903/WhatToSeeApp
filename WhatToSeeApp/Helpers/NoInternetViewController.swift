//
//  File.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//


import UIKit
import Network

protocol NoInternetViewControllerDelegate: AnyObject {
    func reloadData()
    func dismissNoInternetViewController()
}

class NoInternetViewController: UIViewController {
  
  weak var delegate: NoInternetViewControllerDelegate?
  
  let messageLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "No Internet Connection"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  let tryAgainButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Try Again", for: .normal)
    button.addTarget(self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(messageLabel)
    view.addSubview(tryAgainButton)
    
    // Add constraints for the label and button
    NSLayoutConstraint.activate([
      messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      tryAgainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      tryAgainButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20)
    ])
  }
  
  @objc func tryAgainButtonTapped() {
    print("tryAgainButtonTapped()")
    checkInternetConnection()
  }
  
  func checkInternetConnection() {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        DispatchQueue.main.async {
          self.delegate?.reloadData()
          print("NoInternetViewController delegate?.reloadData()")
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
    
    monitor.start(queue: queue)
  }
}
