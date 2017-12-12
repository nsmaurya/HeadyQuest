//
//  SettingViewController.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import UIKit

enum Sorting:Int {
  case mostPopular, highestRated
}
protocol SortingSelectedProtocol:class {
    func didSelectSorting(sortingOption:Sorting)
}
class SettingViewController: UIViewController {
    
    @IBOutlet weak var sortingTableView: UITableView!
    let dataList = ["Most popular", "Highest rated"]
    weak var sortingDelegate:SortingSelectedProtocol?
    var selectedSortingOption:Sorting?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortingTableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.accessoryType = .none
        if let selectedSort = self.selectedSortingOption {
            if selectedSort.rawValue == indexPath.row {
                cell.accessoryType = .checkmark
            }
        }
        cell.textLabel?.text = dataList[indexPath.row]
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
        self.sortingDelegate?.didSelectSorting(sortingOption: selectedSortingOption)
        self.navigationController?.popViewController(animated: true)
    }
}
