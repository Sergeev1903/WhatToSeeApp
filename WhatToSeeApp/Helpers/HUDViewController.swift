//
//  HUD.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//

import UIKit

final class HUDViewController: UIViewController {
  
  // MARK: - Properties
  private let hudView = UIView()
  private let hudLabel = UILabel()
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    setupHudView()
    setupHudLabel()
  }
  
  
  // MARK: - Methods
  private func setupHudView() {
    hudView.backgroundColor = .white.withAlphaComponent(0.7)
    hudView.layer.cornerRadius = 10
    hudView.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(hudView)
    
    NSLayoutConstraint.activate([
      hudView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      hudView.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      hudView.leadingAnchor.constraint(
        greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
      hudView.trailingAnchor.constraint(
        lessThanOrEqualTo: view.trailingAnchor, constant: -20)
    ])
  }
  
  private func setupHudLabel() {
    hudLabel.textColor = .systemBackground
    hudLabel.font = .boldSystemFont(ofSize: 18)
    hudLabel.textAlignment = .center
    hudLabel.translatesAutoresizingMaskIntoConstraints = false
    
    hudView.addSubview(hudLabel)
    
    NSLayoutConstraint.activate([
      hudLabel.topAnchor.constraint(
        equalTo: hudView.topAnchor, constant: 10),
      hudLabel.bottomAnchor.constraint(
        equalTo: hudView.bottomAnchor, constant: -10),
      hudLabel.leadingAnchor.constraint(
        equalTo: hudView.leadingAnchor, constant: 10),
      hudLabel.trailingAnchor.constraint(
        equalTo: hudView.trailingAnchor, constant: -10)
    ])
  }
  
}


extension HUDViewController {
  
  // MARK: - show HUD and hide
  func showHUDAndHide(withText text: String) {
    hudLabel.text = text
    view.alpha = 0
    hudView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
    
    UIView.animate(withDuration: 0.2) {
      self.view.alpha = 1
      self.hudView.transform = CGAffineTransform.identity
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      UIView.animate(withDuration: 0.2, animations: {
        self.view.alpha = 0
        self.hudView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
      }) { _ in
        self.dismiss(animated: false, completion: nil)
      }
    }
  }
  
  // MARK: - show HUD and hide to top
  func showHUDAndHideToTop(withText text: String) {
    hudLabel.text = text
    view.alpha = 0
    
    UIView.animate(withDuration: 0.3, animations: {
      self.view.alpha = 1
      self.hudView.frame.origin.y =
      (self.view.frame.height - self.hudView.frame.height) / 2
    }, completion: { _ in
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        UIView.animate(withDuration: 0.3, animations: {
          self.view.alpha = 0
          self.hudView.frame.origin.y = -self.hudView.frame.height
        }, completion: { _ in
          self.dismiss(animated: false, completion: nil)
        })
      }
    })
  }
  
}
