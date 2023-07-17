//
//  RequestError.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation

enum RequestError: Error {
  case decode
  case invalidURL
  case noResponse
  case unauthorized
  case unexpectedStatusCode
  case unknown
  
  var customMessage: String {
    switch self {
    case .decode:
      return "Decode error"
    case .unauthorized:
      return "Session expired"
    default:
      return "Unknown error"
    }
  }
}
