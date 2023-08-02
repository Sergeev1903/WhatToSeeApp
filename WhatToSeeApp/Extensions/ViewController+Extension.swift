//
//  ViewController+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

extension UIViewController {
  
  func createBarButton(
    image: UIImage, size: Int, selector: Selector) -> UIBarButtonItem {
      
      //    let customButtonImage = image.withTintColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.09775972682), renderingMode: .alwaysOriginal)
      let customButtonImage = image
      let customButtonSize = CGSize(width: size, height: size)
      UIGraphicsBeginImageContextWithOptions(customButtonSize, false, 0.0)
      customButtonImage.draw(in: CGRect(origin: .zero, size: customButtonSize))
      
      let customResizedButtonImage =
      UIGraphicsGetImageFromCurrentImageContext()?
        .withRenderingMode(.alwaysOriginal)
      UIGraphicsEndImageContext()
      
      let customButton = UIBarButtonItem(
        image: customResizedButtonImage,
        style: .plain,
        target: self,
        action: selector)
      
      return customButton
    }

}



