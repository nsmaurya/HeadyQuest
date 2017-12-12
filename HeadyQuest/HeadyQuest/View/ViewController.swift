//
//  ViewController.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {
    //outlets
    
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    var movieList = [Movie]()
    //variables
    lazy var movieInteractor = MovieInteractor()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieTableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.movieTableView.rowHeight = UITableViewAutomaticDimension
        movieInteractor.delegate = self
        //Getting configuration data for image
        movieInteractor.getConfiguration()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let settingsVC = segue.destination as? SettingViewController
            settingsVC?.sortingDelegate = self
            settingsVC?.selectedSortingOption = self.movieInteractor.selectedSortingOption
        }
    }
}

extension ViewController:MovieSearchProtocol {
    func didReceiveSearchedMovieData(_ movies: [Movie]) {
        if let currentPage = self.movieInteractor.currentPage, currentPage == 1 {
            movieList = movies
        } else {
            movieList.append(contentsOf: movies)
        }
        if movieList.isEmpty {
            
        } else {
            self.movieList = self.movieInteractor.sorting(movieData: movieList)
            self.movieTableView.reloadData()
        }
    }
    func didFailToReceiveSearchedMovieData(errorState: ErrorState) {
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text ?? "")
        if let queryString = searchBar.text, !queryString.isEmpty {
            movieInteractor.getMovieViaSearch(query: queryString)
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSummaryTableViewCell", for: indexPath) as? MovieSummaryTableViewCell else {
            fatalError("Error: MovieSummaryTableViewCell not found..")
        }
        cell.movieTitleLabel.text = self.movieList[indexPath.row].title
        if let url = self.movieInteractor.getPosterUrl(imagePath: self.movieList[indexPath.row].posterPath) {
            cell.movieImageView.af_setImage(withURL: url,
                                        placeholderImage: #imageLiteral(resourceName: "no_movie_poster"),
                                        imageTransition: .crossDissolve(0.5),
                                        completion: nil)
        } else {
            cell.movieImageView.image = #imageLiteral(resourceName: "no_movie_poster")
        }
        if indexPath.row == (movieList.count-1) {
            if let currentPage = self.movieInteractor.currentPage, let totalPages = self.movieInteractor.totalPages, currentPage < totalPages {
                if let queryString = movieSearchBar.text {
                    self.movieInteractor.getMovieViaSearch(query: queryString, currentPage: currentPage + 1)
                }
            }
        }
        return cell
    }
    
}

extension ViewController: SortingSelectedProtocol {
    func didSelectSorting(sortingOption: Sorting) {
        self.movieInteractor.setSorting(sorting: sortingOption)
        self.movieList = self.movieInteractor.sorting(movieData: movieList)
        self.movieTableView.reloadData()
    }
}

//Mark:- Movie TableView Cell
class MovieSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowColor = UIColor(white: 0.54, alpha: 1).cgColor
    }
}
