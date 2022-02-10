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
}

extension Valute {
    static func getSelectList() -> [Valute] {
        var dataManager: [Valute] = []
        
        let flags = DataManager.shared.flag
        let abbreviations = DataManager.shared.abbreviation
        let names = DataManager.shared.name
        let check = DataManager.shared.check
        
        let iteration = min(flags.count, abbreviations.count, names.count, check.count)
        
        for index in 0..<iteration {
            let selectList = Valute(flag: flags[index],
                                    abbreviation: abbreviations[index],
                                    name: names[index],
                                    check: check[index]
            )
            dataManager.append(selectList)
        }
        
        return dataManager
    }
}
