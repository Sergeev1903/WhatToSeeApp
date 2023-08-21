//
//  ViewController+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


// Setup navigation bar
extension UIViewController {
  
  func setupNavigationBar(withLargeTitles isLargeTitles: Bool) {
    navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.prefersLargeTitles = isLargeTitles
    navigationController?.navigationBar.tintColor = nil
  }
  
  func setupNavigationBar(withTransparent: Bool) {
    // Make the Navigation Bar background transparent
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = withTransparent
    navigationController?.navigationBar.tintColor = .white
  }
  
}


// Create custom bar button
extension UIViewController {
  
  func createBarButton(
    image: UIImage, imageTintColor: UIColor? = nil,
    size: Int, selector: Selector) -> UIBarButtonItem {
      
      var buttonImage = image
      
      if imageTintColor != nil {
        buttonImage = image.withTintColor(
          imageTintColor!, renderingMode: .alwaysOriginal)
      }
      
      let buttonSize = CGSize(width: size, height: size)
      UIGraphicsBeginImageContextWithOptions(buttonSize, false, 0.0)
      buttonImage.draw(in: CGRect(origin: .zero, size: buttonSize))
      
      let resizedButtonImage =
      UIGraphicsGetImageFromCurrentImageContext()?
        .withRenderingMode(.alwaysOriginal)
      UIGraphicsEndImageContext()
      
      let barButton = UIBarButtonItem(
        image: resizedButtonImage,
        style: .plain,
        target: self,
        action: selector)
      
      return barButton
    }

}



