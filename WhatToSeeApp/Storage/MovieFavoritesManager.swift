//
//  File.swift
//  WhatToSeeApp
//
//  Created by Артем Сергеев on 12.08.2023.
//

import Foundation

class MovieFavoritesManager {
    static let shared = MovieFavoritesManager()
    
    private init() {}
    
    // Store favorite movie IDs using UserDefaults
    func addToFavorites(movieID: Int) {
        var favoriteIDs = UserDefaults.standard.array(forKey: "favoriteMovieIDs") as? [Int] ?? []
        if !favoriteIDs.contains(movieID) {
            favoriteIDs.append(movieID)
            UserDefaults.standard.set(favoriteIDs, forKey: "favoriteMovieIDs")
        }
    }
    
    // Remove a movie ID from favorites
    func removeFromFavorites(movieID: Int) {
        var favoriteIDs = UserDefaults.standard.array(forKey: "favoriteMovieIDs") as? [Int] ?? []
        if let index = favoriteIDs.firstIndex(of: movieID) {
            favoriteIDs.remove(at: index)
            UserDefaults.standard.set(favoriteIDs, forKey: "favoriteMovieIDs")
        }
    }
    
    // Check if a movie is in favorites
    func isFavorite(movieID: Int) -> Bool {
        let favoriteIDs = UserDefaults.standard.array(forKey: "favoriteMovieIDs") as? [Int] ?? []
        return favoriteIDs.contains(movieID)
    }
}

