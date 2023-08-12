//
//  ViewController+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit


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



