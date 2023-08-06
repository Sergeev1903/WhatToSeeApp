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
  
  weak var delegate: NoInternetViewControllerDelegate?
  
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
    button.addTarget(self,
                     action: #selector(tryAgainButtonTapped),
                     for: .touchUpInside)
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
      
      noConnectionAnimation.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      noConnectionAnimation.leadingAnchor.constraint(
        equalTo: view.leadingAnchor),
      noConnectionAnimation.trailingAnchor.constraint(
        equalTo: view.trailingAnchor),
      noConnectionAnimation.bottomAnchor.constraint(
        equalTo: messageLabel.topAnchor),
      
      messageLabel.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      messageLabel.centerYAnchor.constraint(
        equalTo: view.centerYAnchor),
      
      tryAgainButton.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      tryAgainButton.topAnchor.constraint(
        equalTo: messageLabel.bottomAnchor, constant: 20)
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
