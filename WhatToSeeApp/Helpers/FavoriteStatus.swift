//
//  HUDViewStatus.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 13.08.2023.
//

import Foundation

enum FavoriteStatus {
  case added
  case removed
  case error(_ errorMessage: String)
  
  var message: String {
    switch self {
    case .added:
      return "Added favorite"
    case .removed:
      return "Removed favorite"
    case .error(let errorMessage):
      return "An error occurred: \(errorMessage)"
    }
  }
  
}

