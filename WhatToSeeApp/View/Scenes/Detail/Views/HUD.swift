//
//  HUD.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//

import UIKit

final class HUDViewController: UIViewController {
  
  let hudView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    view.layer.cornerRadius = 10
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let label: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.white
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .clear
    view.addSubview(hudView)
    hudView.addSubview(label)
    
    NSLayoutConstraint.activate([
      hudView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor),
      hudView.centerXAnchor.constraint(
        equalTo: view.centerXAnchor),
      hudView.leadingAnchor.constraint(
        greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
      hudView.trailingAnchor.constraint(
        lessThanOrEqualTo: view.trailingAnchor, constant: -20),
      
      label.topAnchor.constraint(
        equalTo: hudView.topAnchor, constant: 10),
      label.bottomAnchor.constraint(
        equalTo: hudView.bottomAnchor, constant: -10),
      label.leadingAnchor.constraint(
        equalTo: hudView.leadingAnchor, constant: 10),
      label.trailingAnchor.constraint(
        equalTo: hudView.trailingAnchor, constant: -10)
    ])
  }
  
  func showHUDAndHide(withText text: String) {
    label.text = text
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
  
  
  func showHUDAndHideToTop(withText text: String) {
    label.text = text
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

