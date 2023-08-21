//
//  UIImage+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 20.08.2023.
//

import UIKit


extension UIImage {
  
  func resized(to targetSize: CGSize) -> UIImage {
    let size = self.size
    
    let widthRatio = targetSize.width / size.width
    let heightRatio = targetSize.height / size.height
    
    let newSize: CGSize
    if widthRatio > heightRatio {
      newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
      newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
    }
    
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let resizedImage = renderer.image { _ in
      self.draw(in: CGRect(origin: CGPoint.zero, size: newSize))
    }
    
    return resizedImage
  }
  
}

