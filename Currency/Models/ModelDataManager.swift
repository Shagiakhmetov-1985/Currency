//
//  ModelDataManager.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

struct Valute {
    let flag: String
    let abbreviation: String
    let name: String
}

extension Valute {
    static func getSelectList() -> [Valute] {
        var dataManager: [Valute] = []
        
        let flags = DataManager.shared.flag
        let abbreviations = DataManager.shared.abbreviation
        let names = DataManager.shared.name
        
        let iteration = min(flags.count, abbreviations.count, names.count)
        
        for index in 0..<iteration {
            let selectList = Valute(flag: flags[index],
                                   abbreviation: abbreviations[index],
                                   name: names[index]
            )
            dataManager.append(selectList)
        }
        
        return dataManager
    }
}
