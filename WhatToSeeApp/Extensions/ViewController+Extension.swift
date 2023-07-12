//
//  ViewController+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 11.07.2023.
//

import UIKit

extension UIViewController {
  
  func createCustomTitleView(name: String, image: String?) -> UIView {
    let nameLabel = UILabel()
    nameLabel.text = name
    nameLabel.frame = CGRect(x: 0, y: 0, width: 280, height: 40)
    nameLabel.numberOfLines = 0
    nameLabel.font = UIFont.systemFont(ofSize: 32)
    view.addSubview(nameLabel)
    
    return view
  }
  
  
  func createCustomBarButton(
    systemImage: String, selector: Selector) -> UIBarButtonItem {
      
      let button = UIButton(type: .system)
      button.setImage(
        UIImage(systemName: systemImage)?.withRenderingMode(.alwaysTemplate),
        for: .normal
      )
      button.tintColor = .systemBlue
      button.imageView?.contentMode = .scaleAspectFit
      button.contentVerticalAlignment = .fill
      button.contentHorizontalAlignment = .fill
      button.addTarget(self, action: selector, for: .touchUpInside)
      
      let menuBarItem = UIBarButtonItem(customView: button)
      return menuBarItem
    }
  
  
  func createCustomBarButton(
    customImage: UIImage, size: Int, selector: Selector) -> UIBarButtonItem {
      
      //    let customButtonImage = image.withTintColor(#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.09775972682), renderingMode: .alwaysOriginal)
      let customButtonImage = customImage
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



