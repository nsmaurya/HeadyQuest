//
//  SettingViewController.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

//MARK:- Sorting Selection Protocol
protocol SortingSelectedProtocol:class {
    func didSelectSorting(sortingOption:Sorting)
}

//MARK:- SettingsViewController
class SettingViewController: UIViewController {
    //IBOutlet
    @IBOutlet weak var sortingTableView: UITableView!
    
    //Variables
    weak var sortingDelegate:SortingSelectedProtocol?
    var selectedSortingOption:Sorting?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    //MARK:- Helper method
    fileprivate func setupTableView() {
        self.sortingTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:- UITableView DataSource & Delegate
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Sorting.count()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.accessoryType = .none
        if let selectedSort = self.selectedSortingOption {
            if selectedSort.rawValue == indexPath.row {//for showing already selected sorting option
                cell.accessoryType = .checkmark
            }
        }
        switch indexPath.row {
            case Sorting.mostPopular.rawValue:
                cell.textLabel?.text = "Most popular"
            case Sorting.highestRated.rawValue:
                cell.textLabel?.text = "Highest rated"
            default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sorting"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedSortingOption = Sorting.mostPopular
        if indexPath.row == 1 {
            selectedSortingOption = Sorting.highestRated
        }
        //apply sorting
        self.sortingDelegate?.didSelectSorting(sortingOption: selectedSortingOption)
        //pop view controller
        self.navigationController?.popViewController(animated: true)
    }
}
