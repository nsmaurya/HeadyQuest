//
//  ViewController.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    lazy var movieInteractor = MovieInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        movieInteractor.delegate = self
        movieInteractor.getMovieViaSearch(query: "A")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController:MovieSearchProtocol {
    func didReceiveSearchedMovieData(_ movies: [Movie]) {
        
    }
    func didFailToReceiveSearchedMovieData(errorState: ErrorState) {
        
    }
}
