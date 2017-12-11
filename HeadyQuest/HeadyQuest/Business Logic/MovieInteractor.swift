//
//  MovieInteractor.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol MovieSearchProtocol: class {
    func didReceiveSearchedMovieData(_ movies: [Movie])
    func didReceiveSearchedMovieData(errorState:ErrorState)
}

class MovieInteractor {
    weak var delegate: MovieSearchProtocol?
    fileprivate let apiManager = APIManager.sharedInstance
    var currentPage:UInt64 = 1
    var totalPages:UInt64 = 0
    
    func getMovieViaSearch(query:String) {
        apiManager.getDataFromMovieSearchAPI(query: query, page:currentPage
            , onSuccess: { (dict) in
                print(dict)
                let json = JSON(dict)
                
        }) { errorState in
            self.delegate?.didReceiveSearchedMovieData(errorState: errorState)
        }
    }
}
