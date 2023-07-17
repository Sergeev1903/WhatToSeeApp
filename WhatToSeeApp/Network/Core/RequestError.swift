//
//  RequestError.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation

enum RequestError: Error {
  case decode
  case encode
  case invalidURL
  case noResponse
  case unauthorized
  case unexpectedStatusCode
  case unknown
  
  var customMessage: String {
    var result = ""
    switch self {
    case .decode:
      result = "Decode error"
    case .encode:
      result = "Encode error"
    case .invalidURL:
      result = "URL error"
    case .noResponse:
      result = "Response error"
    case .unauthorized:
      result = "Session expired"
    case .unexpectedStatusCode:
      result = "Unexpected error"
    case .unknown:
      result = "Unknown error"
    }
    return result
  }
}
