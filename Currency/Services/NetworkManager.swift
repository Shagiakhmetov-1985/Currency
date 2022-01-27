//
//  NetworkManager.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchData(from url: String, with complition: @escaping (Exchange, [DataCurrency]) -> Void) {
        
        guard let getURL = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: getURL) { data, _, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let dateExchange = try JSONDecoder().decode(Exchange.self, from: data)
                let exchange = dateExchange.Valute.map { $0.value }
                complition(dateExchange, exchange)
            } catch let error {
                print("Ошибка получения данных:", error)
            }
        }.resume()
    }
}
