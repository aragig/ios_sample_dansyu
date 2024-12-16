//
//  AlcoholPreset.swift
//  AlcoholPresetSampleApp
//
//  Created by Toshihiko Arai on 2024/12/12.
//

import Foundation

class AlcoholPreset {
    var name: String
    var alcoholPercentage: Double // アルコール度数 (%)
    var volume: Int // 量 (ml)
    var pureAlcohol: Double { // 純アルコール量 (ml)
        let val = (alcoholPercentage / 100) * Double(volume) * 0.8
        return round(val * 10) / 10 // 小数点以下で1桁四捨五入
    }
    
    init(name: String, alcoholPercentage: Double, volume: Int) {
        self.name = name
        self.alcoholPercentage = alcoholPercentage
        self.volume = volume
    }
}
