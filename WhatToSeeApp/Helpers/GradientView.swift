//
//  Gradient.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 01.08.2023.
//

import UIKit

class GradientView: UIView {
  
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
  
  
  private weak var gradientLayer: CAGradientLayer!
  
  convenience init(colors: [UIColor],
                   startPoint: Point = .top,
                   endPoint: Point = .bottom,
                   locations: [NSNumber] = [0, 1]) {
    
    self.init(frame: .zero)
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    layer.addSublayer(gradientLayer)
    
    self.gradientLayer = gradientLayer
    set(colors: colors,
        startPoint: startPoint,
        endPoint: endPoint,
        locations: locations)
    backgroundColor = .clear
  }
  
  func set(colors: [UIColor],
           startPoint: Point = .top,
           endPoint: Point = .bottom,
           locations: [NSNumber] = [0, 1]) {
    
    gradientLayer.colors = colors.map { $0.cgColor }
    gradientLayer.startPoint = startPoint.point
    gradientLayer.endPoint = endPoint.point
    gradientLayer.locations = locations
  }
  
  func setupConstraints() {
    guard let parentView = superview else { return }
    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
    leftAnchor.constraint(equalTo: parentView.leftAnchor).isActive = true
    parentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    parentView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard let gradientLayer = gradientLayer else { return }
    gradientLayer.frame = frame
    
    superview?.addSubview(self)
  }
}


