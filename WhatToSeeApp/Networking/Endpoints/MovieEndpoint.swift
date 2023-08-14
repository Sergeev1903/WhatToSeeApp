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
  case trending = "Trending"
  case genres = "Genres"
}

enum MovieEndpoint {
  case upcoming
  case nowPlaying(page: Int)
  case popular(page: Int)
  case topRated(page: Int)
  case trending(page: Int)
  case movieDetails(id: Int)
  case searchMovie(searchText: String, page: Int)
  case favoriteMovies(page: Int)
  case addFavoriteMovie(movieId: Int)
  case removeFavoriteMovie(movieId: Int)
}

extension MovieEndpoint: Endpoint {
  
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
      return "/3/trending/movie/day"
    case .movieDetails(id: let id):
      return "/3/movie/\(id)"
    case .searchMovie:
      return "/3/search/movie"
    case .favoriteMovies:
      return "/3/account/\(accountID)/favorite/movies"
    case .addFavoriteMovie, .removeFavoriteMovie:
      return "/3/account/\(accountID)/favorite"
    }
  }
  
  var method: RequestMethod {
    switch self {
      
    case .nowPlaying, .popular, .topRated,
        .upcoming, .trending, .movieDetails,
        .searchMovie, .favoriteMovies:
      return .get
      
    case .addFavoriteMovie, .removeFavoriteMovie:
      return .post
    }
  }
  
  var header: [String: String]? {
    switch self {
      
    case .nowPlaying, .popular, .topRated, .upcoming,
        .trending, .movieDetails, .searchMovie,
        .favoriteMovies, .addFavoriteMovie, .removeFavoriteMovie:
      return [
        "Authorization": "Bearer \(accessToken)",
        "Content-Type": "application/json;charset=utf-8"
      ]
      
    }
  }
  
  var queryItems: [URLQueryItem]? {
    switch self {
      
    case .nowPlaying(let page), .popular(let page),
        .topRated(let page), .trending(let page), .favoriteMovies(let page):
      return [URLQueryItem(name: "page", value: "\(page)")]
      
    case .movieDetails:
      return [URLQueryItem(name: "append_to_response", value: "videos")]
      
    case .upcoming, .addFavoriteMovie, .removeFavoriteMovie:
      return nil
      
    case .searchMovie(searchText: let searchText, page: let page ):
      return [URLQueryItem(name: "query", value: "\(searchText)"),
              URLQueryItem(name: "page", value: "\(page)")]
      
    }
  }
  
  var body: [String : Any]? {
    switch self {
      
    case .nowPlaying, .popular, .topRated,
        .upcoming, .trending, .movieDetails,
        .searchMovie, .favoriteMovies:
      return nil
      
    case .addFavoriteMovie(let movieId):
      return ["media_type": "movie", "media_id": movieId, "favorite": true]
      
    case .removeFavoriteMovie(let movieId):
      return ["media_type": "movie", "media_id": movieId, "favorite": false]
    }
  }
  
}
