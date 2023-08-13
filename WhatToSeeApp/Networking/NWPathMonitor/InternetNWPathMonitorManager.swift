//
//  InternetConnectionManager.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 06.08.2023.
//

import UIKit
import Network


class InternetNWPathMonitorManager {
  
  // MARK: - Properties
  static let shared = InternetNWPathMonitorManager()
  
  private let monitor = NWPathMonitor()
  private let queue = DispatchQueue(label: "InternetConnectionMonitor")
  
  // MARK: - Delegate
  weak var noInternetViewController: NoInternetViewController?
  
  
  // MARK: - Init
  private init() {}
  
  
  // MARK: - Methods
  public func startMonitoring() {
    monitor.pathUpdateHandler = { path in
      if path.status == .unsatisfied {
        DispatchQueue.main.async {
          // If internet is not available
          if let topViewController = UIApplication.topViewController() {
            let noInternetVC = NoInternetViewController()
            noInternetVC.modalPresentationStyle = .overFullScreen
            noInternetVC.modalTransitionStyle = .crossDissolve
            noInternetVC.delegate = topViewController as? any NoInternetViewControllerDelegate
            
            self.noInternetViewController = noInternetVC
            
            topViewController.present(noInternetVC, animated: true, completion: nil)
          }
        }
      }
    }
    
    monitor.start(queue: queue)
  }
  
  public func stopMonitoring() {
    monitor.cancel()
  }
  
}


extension UIApplication {
  
  class func topViewController(controller: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
    
    if let navigationController = controller as? UINavigationController {
      return topViewController(controller: navigationController.visibleViewController)
    }
    
    if let tabController = controller as? UITabBarController {
      if let selected = tabController.selectedViewController {
        return topViewController(controller: selected)
      }
    }
    
    if let presented = controller?.presentedViewController {
      return topViewController(controller: presented)
    }
    return controller
  }
  
}

