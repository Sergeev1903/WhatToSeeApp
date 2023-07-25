//
//  TMDBMovie.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.07.2023.
//

import Foundation


// MARK: - TMDBMovieResponse
struct TMDBMovieResponse: Codable {
  let page: Int
  let results: [TMDBMovieResult]
  let totalPages, totalResults: Int
}


// MARK: - TMDBMovieResult
struct TMDBMovieResult: Codable {
  let adult: Bool?
  let backdropPath: String?
  let genreIDS: [Int]?
  let id: Int?
  let originalTitle, overview: String?
  let popularity: Double?
  let posterPath, releaseDate, title: String?
  let video: Bool?
  let voteAverage: Double?
  let voteCount: Int?
  
  var backdropURL: URL {
    return URL(string: "https://image.tmdb.org/t/p/original\(backdropPath ?? "")")!
  }
  
  var posterURL: URL {
    return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")!
  }
}

