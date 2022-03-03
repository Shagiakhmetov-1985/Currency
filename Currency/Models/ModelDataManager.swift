//
//  ModelDataManager.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

struct Valute: Codable {
    let flag: String
    let abbreviation: String
    let name: String
    var check: String
    var nominal: Int
    var value: Double
    var currentValue: Double
}

extension Valute {
    static func getSelectList() -> [Valute] {
        var dataManager: [Valute] = []
        
        let flags = DataManager.shared.flag
        let abbreviations = DataManager.shared.abbreviation
        let names = DataManager.shared.name
        var check: [String] = []
        var nominal: [Int] = []
        var value: [Double] = []
        var currentValue: [Double] = []
        
        let iteration = min(flags.count, abbreviations.count, names.count)
        
        for index in 0..<iteration {
            check.append("")
            nominal.append(0)
            value.append(0)
            currentValue.append(0)
            let selectList = Valute(flag: flags[index],
                                    abbreviation: abbreviations[index],
                                    name: names[index],
                                    check: check[index],
                                    nominal: nominal[index],
                                    value: value[index],
                                    currentValue: currentValue[index]
            )
            dataManager.append(selectList)
        }
        
        return dataManager
    }
}
