//
//  ModelDataManager.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 23.01.2022.
//

struct Model {
    let flag: String
    let abbreviation: String
    let name: String
}

extension Model {
    static func getSelectList() -> [Model] {
        var dataManager: [Model] = []
        
        let flags = DataManager.shared.flag
        let abbreviations = DataManager.shared.abbreviation
        let names = DataManager.shared.name
        
        let iteration = min(flags.count, abbreviations.count, names.count)
        
        for index in 0..<iteration {
            let selectList = Model(flag: flags[index],
                                   abbreviation: abbreviations[index],
                                   name: names[index]
            )
            dataManager.append(selectList)
        }
        
        return dataManager
    }
}
