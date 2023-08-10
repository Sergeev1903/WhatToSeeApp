//
//  Endpoint.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation


protocol Endpoint {
  var apiKey: String { get }
  var accessToken: String { get }
  var scheme: String { get }
  var host: String { get }
  var path: String { get }
  var method: RequestMethod { get }
  var header: [String: String]? { get }
  var body: [String: String]? { get }
  var queryItems: [URLQueryItem]? { get }
}

extension Endpoint {
  
  var apiKey: String {
    return "4f586e20aeada54a820a56ba58751747"
  }
  
  var accessToken: String {
    return "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ZjU4NmUyMGFlYWRhNTRhODIwYTU2YmE1ODc1MTc0NyIsInN1YiI6IjY0MDc3NDdmM2UyZWM4MDA3OTA5MzYxNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.UtWPCFt9Ix-nvuSFEiIDz_HXWtKWHKYLKItB_INdSk0"
  }
  
  var scheme: String {
    return "https"
  }
  
  var host: String {
    return "api.themoviedb.org"
  }
  
  var body: [String: String]? {
    return nil
  }
  
}
