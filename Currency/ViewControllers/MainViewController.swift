//
//  MainViewController.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

import UIKit

protocol AddNewValuteDelegate {
    func saveValute(value: Valute)
}

class MainViewController: UITableViewController {
    
    private var dataExchanges: [Valute] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        dataExchanges = StorageManager.shared.fetchValutes()
//        fetchData(from: URLS.currencyapi.rawValue)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newValuteVC = segue.destination as! SelectNewValuteViewController
        newValuteVC.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataExchanges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrencyMainViewCell
        let data = dataExchanges[indexPath.row]
        
        cell.imageViewMain.image = UIImage(named: data.flag)
        cell.imageViewMain.layer.cornerRadius = 5
        cell.imageViewMain.layer.borderWidth = 2
        cell.imageViewMain.layer.borderColor = CGColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        cell.labelCurrency.text = data.abbreviation
        cell.labelDescription.text = data.name
//        cell.textFieldMain.text = string(for: data.Value ?? 0)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteValute(valute: indexPath.row)
            dataExchanges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func fetchData(from url: String) {
        NetworkManager.shared.fetchData(from: url) { date, exchange in
            DispatchQueue.main.async {
//                self.dataExchanges = exchange
                self.tableView.reloadData()
                self.title = "Курсы на " + date.Date
            }
        }
    }
    
    private func string(for data: Double) -> String {
        String(format: "%.2f", data)
    }

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
}

extension MainViewController: AddNewValuteDelegate {
    func saveValute(value: Valute) {
        dataExchanges.append(value)
        tableView.reloadData()
    }
}
