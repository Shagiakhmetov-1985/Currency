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

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Select") as! CurrencyViewCell
        let data = selectList[indexPath.row]
        
        cell.imageFlag.image = UIImage(named: data.flag)
        cell.labelAbbreviation.text = data.abbreviation
        cell.labelCountry.text = data.name
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
