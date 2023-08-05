//
//  HUDView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//

import UIKit

class HUDView: UIView {
  
  private let label = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }
  
  private func setupViews() {
    // Customize your HUD appearance here
    backgroundColor = UIColor.black.withAlphaComponent(0.7)
    layer.cornerRadius = 8.0
    clipsToBounds = true
    
    // Add label
    label.textColor = UIColor.white
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(label)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      label.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
  
}


extension HUDView {
  
  // MARK: -
  func showHUDAndHide(with text: String) {
    label.text = text
    alpha = 0
    
    guard let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController(),
          let containerView = topViewController.view else {
      return
    }
    
    containerView.addSubview(self)
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 1.0
    }) { (_) in
      self.perform(#selector(self.hide), with: nil, afterDelay: 2.0)
    }
  }
  
  // action for showHUDAndHide
  @objc private func hide() {
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 0
    }) { (_) in
      self.removeFromSuperview()
    }
  }
  
  // MARK: -
  func showHUDAndHideToTop(with text: String) {
    label.text = text
    alpha = 0
    
    guard let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController(),
          let containerView = topViewController.view else {
      return
    }
    
    containerView.addSubview(self)
    
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 1.0
      self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }) { (_) in
      self.perform(#selector(self.hideToTop), with: nil, afterDelay: 2.0)
    }
  }
  
  // action for showHUDAndHideToTop
  @objc private func hideToTop() {
    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 0
      self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
    }) { (_) in
      self.removeFromSuperview()
      self.transform = .identity
    }
  }
  
}


// MARK: -
extension UIViewController {
  func topMostViewController() -> UIViewController {
    if let presented = presentedViewController {
      return presented.topMostViewController()
    }
    
    if let navigationController = self as? UINavigationController {
      return navigationController.visibleViewController?.topMostViewController() ?? navigationController
    }
    
    if let tabBarController = self as? UITabBarController {
      return tabBarController.selectedViewController?.topMostViewController() ?? tabBarController
    }
    
    return self
  }
}
