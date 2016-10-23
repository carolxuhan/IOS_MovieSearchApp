//
//  Movie.swift
//  MovieSearchApp
//
//  Created by Carol Han on 10/17/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import Foundation
import UIKit

class Movie {
    var title = ""
    var poster = UIImage(named: "noPoster")
    var imdbId = ""
    var plot = ""
    var released = ""
    var director = ""
    var imdbRating = ""
    var added = false
    
    init(){
        self.title = "N/A"
        self.imdbId = "N/A"
        self.poster = nil
    }
    
    static func convertToMoive(savedMovie: FavoriteMovie) -> Movie {
        let movie = Movie()
        movie.added = true
        movie.imdbId = savedMovie.imdbId
        movie.poster = UIImage(data: savedMovie.poster)
        movie.title = savedMovie.title
        return movie
    }
}