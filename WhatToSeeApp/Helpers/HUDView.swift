//
//  HUDView.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 05.08.2023.
//

import UIKit


final class HUDView: UIView {
  
  // MARK: - Properties
  private let label = UILabel()
  
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    print("Sorry! only code, no storyboards")
    return nil
  }
  
  
  // MARK: - Setup views
  private func setupViews() {
    // HUDView
    backgroundColor = .white.withAlphaComponent(0.7)
    layer.cornerRadius = 10
    clipsToBounds = true
    
    // Label
    label.textColor = .black.withAlphaComponent(0.7)
    label.font = .boldSystemFont(ofSize: 18)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(label)
    
    NSLayoutConstraint.activate([
      
      self.widthAnchor.constraint(
        lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2),
      
      label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
      label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
      label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
    ])
  }
  
  // MARK: - show HUD and hide
 public func showHUD(with message: String, andIsHideToTop: Bool) {
    label.text = message
    alpha = 0
    
    guard let topViewController = UIApplication.shared.windows.first?.rootViewController?.topMostViewController(),
          let containerView = topViewController.view else {
      return
    }
    
    containerView.addSubview(self)
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 1.0
    }) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        
        switch andIsHideToTop {
        case true:
          self.hideToTop()
        case false:
          self.hide()
        }
      }
    }
  }
  
  // action for showHUD hide
  @objc private func hide() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 0
    }) { _ in
      self.removeFromSuperview()
    }
  }
  
  // action for showHUD hide to top
  @objc private func hideToTop() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
      self.alpha = 0
      self.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
    }) { _ in
      self.transform = .identity
      self.removeFromSuperview()
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
