//
//  SelectTableViewController.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

import UIKit

class SelectTableViewController: UITableViewController {
    
    var selectList = Model.getSelectList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select", for: indexPath) as! CurrencyViewCell
        let data = selectList[indexPath.row]
        
        cell.imageFlag.image = UIImage(named: data.flag)
        cell.labelAbbreviation.text = data.abbreviation
        cell.labelCountry.text = data.name
        
        return cell
    }
}
