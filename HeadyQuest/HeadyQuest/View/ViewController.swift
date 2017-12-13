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
    //IBOutlets
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    //Variables
    var movieList = [Movie]()
    lazy var movieInteractor = MovieInteractor()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.movieInteractor.delegate = self
        //Getting configuration data for image
        self.movieInteractor.getConfiguration()
    }
    
    //MARK:- Helper method
    fileprivate func setupTableView() {
        self.movieTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    fileprivate func getTableFooterView() -> UIView? {
        let tableFooterView = Bundle.main.loadNibNamed("MovieSummaryTableFooterView", owner: nil,options: nil)?.first as? UIView
        tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.movieTableView.frame.size.width, height: 52.0)
        return tableFooterView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Settings" {
            let settingsVC = segue.destination as? SettingViewController
            settingsVC?.sortingDelegate = self
            settingsVC?.selectedSortingOption = self.movieInteractor.selectedSortingOption
        } else {
            let movieDetailVC = segue.destination as? MovieDetailViewController
            movieDetailVC?.movie = sender as? Movie
        }
    }
}

//MARK:- Movie Search Delegate
extension ViewController:MovieSearchProtocol {
    func didReceiveSearchedMovieData(_ movies: [Movie]) {
        self.movieTableView.tableFooterView = nil
        if let currentPage = self.movieInteractor.currentPage, currentPage == 1 {
            movieList = movies
        } else {
            movieList.append(contentsOf: movies)
        }
        if movieList.isEmpty {
            self.movieTableView.isHidden = true
            self.messageImageView.image = #imageLiteral(resourceName: "no_movie_poster")
            self.messageLabel.text = "No results found"
        } else {
            self.movieTableView.isHidden = false
            //apply sorting if user choosed any sorting option
            self.movieList = self.movieInteractor.sorting(movieData: movieList)
            self.movieTableView.reloadData()
        }
    }
    
    func didFailToReceiveSearchedMovieData(errorState: ErrorState) {
        if (errorState == ErrorState.noNetwork && self.movieList.isEmpty) || errorState == ErrorState.emptyState {//since constant hitting api and doing manual fail, so managed for only no network & for empty state
            self.movieTableView.isHidden = true
            self.messageLabel.text = errorState.getErrorMessage()
            if errorState == ErrorState.emptyState {
                self.messageImageView.image = #imageLiteral(resourceName: "no_movie_poster")
            } else {
                self.messageImageView.image = #imageLiteral(resourceName: "no_internet")
            }
        } else {//for failure
            
        }
    }
}

//MARK:- SearchBar Delegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let queryString = searchBar.text, !queryString.isEmpty {
            movieInteractor.getMovieViaSearch(query: queryString)
        }
    }
}

//MARK:- UITableView DataSource & Delegate
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSummaryTableViewCell", for: indexPath) as? MovieSummaryTableViewCell else {
            fatalError("Error: MovieSummaryTableViewCell not found..")
        }
        cell.movieTitleLabel.text = self.movieList[indexPath.row].title
        if let url = getPosterUrl(imagePath: self.movieList[indexPath.row].posterPath) {
            cell.movieImageView.af_setImage(withURL: url,
                                        placeholderImage: #imageLiteral(resourceName: "no_movie_poster"),
                                        imageTransition: .crossDissolve(0.5),
                                        completion: nil)
        } else {
            cell.movieImageView.image = #imageLiteral(resourceName: "no_movie_poster")
        }
        //for getting paginated data
        if indexPath.row == (movieList.count-1) {//if at last row
            if let currentPage = self.movieInteractor.currentPage, let totalPages = self.movieInteractor.totalPages, currentPage < totalPages {//if current page < total pages
                if let queryString = movieSearchBar.text {
                    //setting table footer for loading purpose
                    self.movieTableView.tableFooterView = getTableFooterView()
                    //hitting api to get page+1 data
                    self.movieInteractor.getMovieViaSearch(query: queryString, currentPage: currentPage + 1)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //hide keyboard
        self.view.endEditing(true)
        //show movie detail page
        performSegue(withIdentifier: "MovieDetail", sender: movieList[indexPath.row])
    }
}

//MARK:- Sorting Delegate
extension ViewController: SortingSelectedProtocol {
    func didSelectSorting(sortingOption: Sorting) {
        //Set sorting option
        self.movieInteractor.setSorting(sorting: sortingOption)
        //Apply sorting
        self.movieList = self.movieInteractor.sorting(movieData: movieList)
        self.movieTableView.reloadData()
    }
}

//MARK:- Movie TableView Cell
class MovieSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code for shadow
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowColor = UIColor(white: 0.54, alpha: 1).cgColor
    }
}
