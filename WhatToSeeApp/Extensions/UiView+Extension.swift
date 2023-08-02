//
//  UiView+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 02.08.2023.
//

import UIKit

extension UIView {
  func addGradientView(
    colors: [UIColor],
    startPoint: GradientView.Point = .top,
    endPoint: GradientView.Point = .bottom,
    locations: [NSNumber] = [0, 1]
  ) {
    let gradientView = GradientView(
      colors: colors,
      startPoint: startPoint,
      endPoint: endPoint,
      locations: locations
    )
    
    addSubview(gradientView)
    gradientView.setupConstraints()
  }
}
