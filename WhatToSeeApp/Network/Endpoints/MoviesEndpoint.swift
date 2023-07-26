//
//  MoviesEndpoint.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 16.07.2023.
//

import Foundation


enum MovieCategory: String, CaseIterable {
  case nowPlaying = "Now Playing"
  case popular = "Popular"
  case topRated = "Top Rated"
//  case upcoming = "Upcoming"
  case trending = "Trending"
}

enum MoviesEndpoint {
  case nowPlaying
  case popular
  case topRated
  case upcoming
  case trending
  case movieDetail(id: Int)
}

extension MoviesEndpoint: Endpoint {
  var path: String {
    switch self {
    case .nowPlaying:
      return "/3/movie/now_playing"
    case .popular:
      return "/3/movie/popular"
    case .topRated:
      return "/3/movie/top_rated"
    case .upcoming:
      return "/3/movie/upcoming"
    case .trending:
      return "/3/trending/movie/week"
    case .movieDetail(id: let id):
      return "/3/movie/\(id)"
    }
  }
  
  var method: RequestMethod {
    switch self {
    case .nowPlaying, .popular, .topRated,
        .upcoming, .trending, .movieDetail:
      return .get
    }
  }
  
  var header: [String: String]? {
    switch self {
    case .nowPlaying, .popular, .topRated,
        .upcoming, .trending, .movieDetail:
      return [
        "Authorization": "Bearer \(accessToken)",
        "Content-Type": "application/json;charset=utf-8"
      ]
    }
  }
}
