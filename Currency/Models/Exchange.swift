//
//  Exchange.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 24.01.2022.
//

import Foundation

struct Exchange: Decodable {
    let Date: String
    var Valute: [String: DataCurrency]
}

struct DataCurrency: Decodable {
    let NumCode: String?
    let CharCode: String?
    let Nominal: Int?
    let Name: String?
    let Value: Double?
}

enum URLS: String {
    case currencyapi = "https://www.cbr-xml-daily.ru/daily_json.js"
}
