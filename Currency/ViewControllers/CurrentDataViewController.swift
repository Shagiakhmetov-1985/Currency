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
        cell.textFieldMain.delegate = self
        cell.textFieldMain.addTarget(self, action: #selector(buttonDoneOnKeyboard(sender:)), for: UIControl.Event.editingDidBegin)
        cell.textFieldMain.tag = indexPath.row
        cell.textFieldMain.addTarget(self, action: #selector(dataEntry(sender:)), for: UIControl.Event.editingChanged)
        cell.textFieldMain.text = string(for: data.currentValue)
        cell.textFieldMain.addTarget(self, action: #selector(setupString(sender:)), for: UIControl.Event.editingDidEnd)
        
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
    
    private func currentValueSetup(text: String) -> Double {
        guard let data = Double(text) else { return 0 }
        return data
    }
    
    private func calculationCurrentValue(firstValue: Double, otherValue: Double, multiplier: Double) -> Double {
        if firstValue == 0 {
            let calculation = multiplier / otherValue
            return calculation
        } else {
            let calculation = (firstValue / otherValue) * multiplier
            return calculation
        }
    }
    
    private func calculationRussianValue(value: Double, multiplier: Double) -> Double {
        let calculation = value * multiplier
        return calculation
    }
    
    private func setupDataTapCell(index: Int, textFieldText: String) {
        let charCodeAPI = dataFromAPI.map({ $0.CharCode })
        
        switch dataExchanges[index].flag {
        
        case "russia":
            
            dataExchanges[index].currentValue = currentValueSetup(text: textFieldText)
            
        default:
            
            guard let indexCharCode = charCodeAPI.firstIndex(of: dataExchanges[index].abbreviation) else { return }
            guard let nominal = dataFromAPI[indexCharCode].Nominal else { return }
            guard let value = dataFromAPI[indexCharCode].Value else { return }
            
            dataExchanges[index].nominal = nominal
            dataExchanges[index].value = value
            dataExchanges[index].currentValue = currentValueSetup(text: textFieldText)
            
        }
    }
    
    private func setupDataOtherCells(index: Int) {
        let charCodeAPI = dataFromAPI.map({ $0.CharCode })
        let iterration = dataExchanges.count
        for indexFromMain in 0..<iterration {
            
            switch dataExchanges[indexFromMain].flag {

            case let flag where !(flag == dataExchanges[index].flag) && !(flag == "russia"):
                
                guard let indexCharCode = charCodeAPI.firstIndex(of: dataExchanges[indexFromMain].abbreviation) else { return }
                guard let nominal = dataFromAPI[indexCharCode].Nominal else { return }
                guard let value = dataFromAPI[indexCharCode].Value else { return }
                let currentValue = calculationCurrentValue(
                    firstValue: dataExchanges[index].value,
                    otherValue: value,
                    multiplier: dataExchanges[index].currentValue
                )
                
                dataExchanges[indexFromMain].nominal = nominal
                dataExchanges[indexFromMain].value = value
                dataExchanges[indexFromMain].currentValue = currentValue

            case let flag where !(flag == dataExchanges[index].flag) && flag == "russia":
                
                guard let indexCharCode = charCodeAPI.firstIndex(of: dataExchanges[index].abbreviation) else { return }
                guard let value = dataFromAPI[indexCharCode].Value else { return }
                let currentValue = calculationRussianValue(
                    value: value,
                    multiplier: dataExchanges[index].currentValue
                )
                
                dataExchanges[indexFromMain].currentValue = currentValue

            default: break
                
            }
        }
    }
    
    private func reloadDataCells(index: Int) {
        let count = dataExchanges.count
        for tag in 0..<count {
            if !(tag == index) {
                tableView.reloadRows(at: [IndexPath.init(row: tag, section: 0)], with: .none)
            }
        }
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
    
    @objc func dataEntry(sender: UITextField) {
        setupDataTapCell(index: sender.tag, textFieldText: sender.text ?? "")
        setupDataOtherCells(index: sender.tag)
        StorageManager.shared.rewriteValutes(valutes: dataExchanges)
        reloadDataCells(index: sender.tag)
    }
    
    @objc func setupString(sender: UITextField) {
        sender.text = string(for: dataExchanges[sender.tag].currentValue)
    }
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
