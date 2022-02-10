//
//  SelectTableViewController.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

import UIKit

class SelectNewValuteViewController: UITableViewController {
    var delegate: AddNewValuteDelegate!
    
    private var selectList: [Valute] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 40
        fetchValutesFromModel()
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
        cell.imageCheckmark.image = UIImage(systemName: data.check)
        cell.imageCheckmark.tintColor = UIColor(red: 50/255, green: 130/255, blue: 50/255, alpha: 1)
        cell.isUserInteractionEnabled = interaction(data: data.check)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = selectList[indexPath.row]
        selectList[indexPath.row].check = "checkmark"
        StorageManager.shared.saveValute(valute: data)
        StorageManager.shared.saveSelectValutes(selectValutes: selectList)
        delegate.saveValute(value: data)
        dismiss(animated: true)
    }
    
    private func interaction(data: String) -> Bool {
        if data == "checkmark" {
            return false
        } else {
            return true
        }
    }
    
    private func fetchValutesFromModel() {
        selectList = StorageManager.shared.fetchSelectValutes()
        if selectList.isEmpty {
            selectList = Valute.getSelectList()
        }
    }
}
