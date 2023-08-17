//
//  File.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//


import UIKit
import Network
import Lottie


protocol NoInternetViewControllerDelegate: AnyObject {
  func reloadData(_ noInternetViewController: NoInternetViewController)
}


class NoInternetViewController: UIViewController {
  
  // MARK: - Delegate
  weak var delegate: NoInternetViewControllerDelegate?
  
  // MARK: - Properties
  var noConnectionAnimation: LottieAnimationView = {
    let animation = LottieAnimationView(name: "noconnection")
    animation.translatesAutoresizingMaskIntoConstraints = false
    animation.contentMode = .scaleAspectFit
    animation.loopMode = .loop
    animation.play()
    return animation
  }()
  
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
    button.addTarget(
      NoInternetViewController.self, action: #selector(tryAgainButtonTapped), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    view.addSubview(noConnectionAnimation)
    view.addSubview(messageLabel)
    view.addSubview(tryAgainButton)
    
    // Add constraints for the label and button
    NSLayoutConstraint.activate([
      
      noConnectionAnimation.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      noConnectionAnimation.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      noConnectionAnimation.centerYAnchor.constraint(
        equalTo: view.centerYAnchor, constant: -50),
      
      messageLabel.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      messageLabel.topAnchor.constraint(
        equalTo: view.centerYAnchor, constant: 100),
      
      tryAgainButton.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      tryAgainButton.topAnchor.constraint(
        equalTo: messageLabel.bottomAnchor, constant: 16)
    ])
  }
  
  // try again button action
  @objc func tryAgainButtonTapped() {
    checkInternetConnection()
  }
  
  
  // MARK: - Methods
  private func checkInternetConnection() {
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    monitor.pathUpdateHandler = { path in
      if path.status == .satisfied {
        DispatchQueue.main.async {
          self.delegate?.reloadData(self)
          self.dismiss(animated: true, completion: nil)
        }
      }
    }
    
    monitor.start(queue: queue)
  }
  
}
