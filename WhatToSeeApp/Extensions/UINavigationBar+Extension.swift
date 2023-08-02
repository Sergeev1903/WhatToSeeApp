//
//  UINavigationBar+Extension.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 01.08.2023.
//

import UIKit

extension UINavigationBar {
  func setGradientBackground(
    colors: [UIColor],
    startPoint: GradientView.Point = .top,
    endPoint: GradientView.Point = .bottom,
    locations: [NSNumber] = [0, 1]) {

      guard let backgroundView =
              value(forKey: "backgroundView") as? UIView else {
        return
      }

      guard let gradientView =
              backgroundView.subviews.first(
                where: { $0 is GradientView }) as? GradientView else {

        let gradientView = GradientView(
          colors: colors,
          startPoint: startPoint,
          endPoint: endPoint,
          locations: locations)

        backgroundView.addSubview(gradientView)
        gradientView.setupConstraints()
        return
      }

      gradientView.set(
        colors: colors,
        startPoint: startPoint,
        endPoint: endPoint,
        locations: locations)
    }
}
