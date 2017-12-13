//
//  Utils.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation

//MARK:- For Getting Poster URL
public func getPosterUrl(imagePath:String?) -> URL? {
    if let baseImageUrl = imageBaseURL, let size = posterSize, let posterPath = imagePath {
        let finalUrlString = baseImageUrl + size + posterPath
        let url = URL.init(string: finalUrlString)
        return url
    }
    return nil
}

//MARK:- For Getting Logo URL
public func getLogoUrl(imagePath:String?) -> URL? {
    if let baseImageUrl = imageBaseURL, let size = logoSize, let posterPath = imagePath {
        let finalUrlString = baseImageUrl + size + posterPath
        let url = URL.init(string: finalUrlString)
        return url
    }
    return nil
}
