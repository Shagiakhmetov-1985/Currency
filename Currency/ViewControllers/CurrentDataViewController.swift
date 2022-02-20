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

class CurrentDataViewController: UITableViewController, UITextFieldDelegate {
    
    private var dataExchanges: [Valute] = []
    private var dataFromAPI: [DataCurrency] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        dataExchanges = StorageManager.shared.fetchValutes()
        fetchData(from: URLS.currencyapi.rawValue)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(sender:))))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let newValuteVC = segue.destination as! SelectNewValuteViewController
        newValuteVC.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataExchanges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CurrentDataViewCell
        let data = dataExchanges[indexPath.row]
        
        cell.imageViewMain.image = UIImage(named: data.flag)
        cell.imageViewMain.layer.cornerRadius = 5
        cell.imageViewMain.layer.borderWidth = 2
        cell.imageViewMain.layer.borderColor = CGColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1)
        cell.labelCurrency.text = data.abbreviation
        cell.labelDescription.text = data.name
//        cell.textFieldMain.tag = indexPath.row
        cell.textFieldMain.delegate = self
        cell.textFieldMain.addTarget(self, action: #selector(buttonDoneOnKeyboard(sender:)), for: UIControl.Event.editingDidBegin)
        cell.textFieldMain.text = string(for: dataOfValute(valute: data))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let data = dataExchanges[indexPath.row]
            StorageManager.shared.deleteValute(valute: indexPath.row)
            dataExchanges.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCheckmark(valute: data)
        }
    }
    
    private func deleteCheckmark(valute: Valute) {
        var valutes = StorageManager.shared.fetchSelectValutes()
        let flags = valutes.map({ $0.flag })
        if let index = flags.firstIndex(of: valute.flag) {
            valutes[index].check = ""
            StorageManager.shared.saveSelectValutes(selectValutes: valutes)
        }
    }
    
    private func fetchData(from url: String) {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.YYYY"
        NetworkManager.shared.fetchData(from: url) { date, exchange in
            DispatchQueue.main.async {
                self.dataFromAPI = exchange
                self.tableView.reloadData()
                self.title = "Курсы на " + formatter.string(from: currentDate)
            }
        }
    }
    
    private func string(for data: Double) -> String {
        String(format: "%.2f", data)
    }
    
    private func dataOfValute(valute: Valute) -> Double {
        let valutes = dataFromAPI
        let charCode = valutes.map({ $0.CharCode })
        guard let index = charCode.firstIndex(of: valute.abbreviation) else { return 0 }
        guard let data = valutes[index].Value else { return 0 }
        return data
    }
    
    @objc func didTapDone() {
        view.endEditing(true)
    }
    
    @objc func buttonDoneOnKeyboard(sender: UITextField) {
        let keyboardToolbar = UIToolbar()
        sender.inputAccessoryView = keyboardToolbar
        keyboardToolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .done,
            target: self,
            action: #selector(didTapDone)
        )
        
        let flexBarButton = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        keyboardToolbar.items = [flexBarButton, doneButton]
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        sender.cancelsTouchesInView = false
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

extension CurrentDataViewController: AddNewValuteDelegate {
    func saveValute(value: Valute) {
        dataExchanges.append(value)
        tableView.reloadData()
    }
}

extension CurrentDataViewController {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, let rangeOfTextToReplace = Range(range, in: text) else { return false }
        let substringToReplace = text[rangeOfTextToReplace]
        let count = text.count - substringToReplace.count + string.count
        return count <= 9
    }
}
