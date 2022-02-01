//
//  StorageManager.swift
//  Currency
//
//  Created by Marat Shagiakhmetov on 01.02.2022.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let userDefaults = UserDefaults.standard
    private let valuteKey = "valutes"
    
    private init() {}
    
    func saveValute(valute: Valute) {
        var valutes = fetchValutes()
        valutes.append(valute)
        guard let data = try? JSONEncoder().encode(valutes) else { return }
        userDefaults.set(data, forKey: valuteKey)
    }
    
    func deleteValute(valute: Int) {
        var valutes = fetchValutes()
        valutes.remove(at: valute)
        guard let data = try? JSONEncoder().encode(valutes) else { return }
        userDefaults.set(data, forKey: valuteKey)
    }
    
    func fetchValutes() -> [Valute] {
        guard let data = userDefaults.object(forKey: valuteKey) as? Data else { return [] }
        guard let valutes = try? JSONDecoder().decode([Valute].self, from: data) else { return [] }
        return valutes
    }
}
