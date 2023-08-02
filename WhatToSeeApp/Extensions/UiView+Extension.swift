//
//  UiView+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 02.08.2023.
//

import UIKit

extension UIView {
  
  // MARK: - self.layer.addSublayer(gradientLayer)
  func setupGradientAddSublayer(
    _ gradientLayer: CAGradientLayer,
    colors: [UIColor],
    startPoint: Point,
    endPoint: Point,
    locations: [NSNumber]? = [0, 1] ) {
      
      gradientLayer.frame = self.bounds
      gradientLayer.colors = colors.map { $0.cgColor }
      gradientLayer.startPoint = startPoint.point
      gradientLayer.endPoint = endPoint.point
      gradientLayer.locations = locations
      
      self.layer.addSublayer(gradientLayer)
    }
  
  // MARK: - self.layer.insertSublayer(gradientLayer, at: index)
  func setupGradientInsertSublayer(
    _ gradientLayer: CAGradientLayer,
    at index: UInt32,
    colors: [UIColor],
    startPoint: Point,
    endPoint: Point,
    locations: [NSNumber]? = [0, 1]) {
      
      gradientLayer.frame = self.bounds
      gradientLayer.colors = colors.map { $0.cgColor }
      gradientLayer.startPoint = startPoint.point
      gradientLayer.endPoint = endPoint.point
      gradientLayer.locations = locations
      
      self.layer.insertSublayer(gradientLayer, at: index)
    }
  
  
  enum Point {
    case top, bottom, center,
         topLeading, leading, bottomLeading,
         topTrailing, trailing, bottomTrailing
    
    var point: CGPoint {
      switch self {
      case .top:
        return CGPoint(x: 0.5, y: 0.0)
      case .bottom:
        return CGPoint(x: 0.5, y: 1.0)
      case .center:
        return CGPoint(x: 0.5, y: 0.5)
      case .topLeading:
        return CGPoint(x: 0, y: 0)
      case .leading:
        return CGPoint(x: 0, y: 0.5)
      case .bottomLeading:
        return CGPoint(x: 0, y: 1.0)
      case .topTrailing:
        return CGPoint(x: 1.0, y: 0.0)
      case .trailing:
        return CGPoint(x: 1.0, y: 0.5)
      case .bottomTrailing:
        return CGPoint(x: 1.0, y: 1.0)
      }
    }
  }
  
}
