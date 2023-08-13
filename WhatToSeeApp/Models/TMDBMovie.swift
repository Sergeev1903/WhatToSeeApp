//
//  TMDBMovie.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation


// MARK: - TMDBMovieResponse
struct TMDBMovieResponse: Codable {
  let results: [TMDBMovieResult]
  let totalResults: Int
  let page: Int
  let totalPages: Int
}

// MARK: - TMDBMovieResult
struct TMDBMovieResult: Codable {
  let id: Int?
  let title: String?
  let originalTitle: String?
  let posterPath: String?
  let backdropPath: String?
  let releaseDate: String?
  let voteAverage: Double?
  let overview: String?
  let genres: [Genre]?
  let videos: Videos?
  
  var posterURL: URL? {
    return URL(
      string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
  }
  
  var backdropURL: URL? {
    return URL(
      string: "https://image.tmdb.org/t/p/original\(backdropPath ?? "")")
  }
  
}


//MARK: - Genres
struct Genres: Codable {
  let genres: [Genre]
}

//MARK: - Genre
struct Genre: Codable {
  let id: Int
  let name: String
}

// MARK: - Videos
struct Videos: Codable {
  let results: [Video]
}

// MARK: - Video
struct Video: Codable {
  let key: String
  let name: String
  let official: Bool
  var keyURL: URL? {
    return URL(string: "https://www.youtube.com/watch?v=\(key)")
  }
  
}
