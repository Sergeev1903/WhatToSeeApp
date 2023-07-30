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


// MARK: - TMDBMovieDetail
struct TMDBMovieDetail: Codable {
  let adult: Bool?
  let backdropPath: String?
  let budget: Int?
  let genres: [Genre]
  let homepage: String?
  let id: Int?
  let imdbID: String?
  let originalTitle, overview: String?
  let popularity: Double?
  let posterPath: String?
  let releaseDate: String?
  let revenue, runtime: Int?
  let status, tagline, title: String?
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
  var keyURL: URL {
    return URL(string: "https://www.youtube.com/watch?v=\(key)")!
  }
  
}
