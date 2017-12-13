//
//  Movie.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper
struct Movie: Mappable {
    //Variables
    var voteCount: UInt64?
    var id: UInt64?
    var video: Bool?
    var voteAverage:Double?
    var title:String?
    var popularity:Double?
    var posterPath:String?
    var originalLanguage:String?
    var originalTitle:String?
    var overview:String?
    var releaseDate:String?
    
    init?(map: Map){}
    
    //MARK:- Mapping with API Response
    mutating func mapping(map: Map) {
        voteCount <- map["vote_count"]
        id <- map["id"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
    }
}
