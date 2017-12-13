//
//  MovieDetailViewController.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    //IBOutlets
    @IBOutlet weak var movieDetailTableView: UITableView!
    
    //Variables
    enum TableRows:Int {
        case movieDetail = 0, overview
        static func count() -> Int {
            return self.overview.rawValue + 1
        }
    }
    var movie:Movie?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Helper method
    fileprivate func setupTableView() {
        self.movieDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

//MARK:- UITableView DataSource & Delegate
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableRows.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
            case TableRows.movieDetail.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as? MovieDetailTableViewCell else {
                    fatalError("Error: MovieDetailTableViewCell not found..")
                }
                cell.movieTitleLabel.text = movie?.title
                if let url = getLogoUrl(imagePath: movie?.posterPath) {
                    cell.movieImageView.af_setImage(withURL: url,
                                                    placeholderImage: #imageLiteral(resourceName: "no_movie_poster"),
                                                    imageTransition: .crossDissolve(0.5),
                                                    completion: nil)
                } else {
                    cell.movieImageView.image = #imageLiteral(resourceName: "no_movie_poster")
                }
                cell.movieRatingImageView.isHidden = true
                if let rating = movie?.voteAverage {
                    cell.movieRatingLabel.text = String.init(format: "%.lf", rating)
                    cell.movieRatingImageView.isHidden = false
                }
                cell.movieReleaseDateTitleLabel.isHidden = true
                if let releaseDate = movie?.releaseDate {
                    cell.movieReleaseDateTitleLabel.isHidden = false
                    cell.movieReleaseDateLabel.text = releaseDate
                }
                return cell
            case TableRows.overview.rawValue:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieOverviewTableViewCell", for: indexPath) as? MovieOverviewTableViewCell else {
                    fatalError("Error: MovieOverviewTableViewCell not found..")
                }
                cell.descriptionLabel.text = movie?.overview
                return cell
            default:
                return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
            case TableRows.movieDetail.rawValue:
                return 150.0
            default:
                return UITableViewAutomaticDimension
        }
    }
}

//MARK:- MovieDetailTableViewCell
class MovieDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieReleaseDateTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieRatingImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

//MARK:- MovieOverviewTableViewCell
class MovieOverviewTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
