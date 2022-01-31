//
//  SelectTableViewController.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

import UIKit

class SelectNewValuteViewController: UITableViewController {
    var delegate: AddNewValuteDelegate!
    
    private var selectList = Valute.getSelectList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 40
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select", for: indexPath) as! CurrencySelectViewCell
        let data = selectList[indexPath.row]
        
        cell.imageFlag.image = UIImage(named: data.flag)
        cell.imageFlag.layer.cornerRadius = 5
        cell.imageFlag.layer.borderWidth = 2
        cell.imageFlag.layer.borderColor = CGColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        cell.labelAbbreviation.text = data.abbreviation
        cell.labelCountry.text = data.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = selectList[indexPath.row]
        let valute = Valute(flag: data.flag, abbreviation: data.abbreviation, name: data.name)
        delegate.saveValute(value: valute)
        dismiss(animated: true)
    }
    
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
}
