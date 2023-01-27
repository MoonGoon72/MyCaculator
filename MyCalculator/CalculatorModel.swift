//
//  CalculatorModel.swift
//  MyCalculator
//
//  Created by cnu on 2023/01/26.
//

import Foundation

class CalculatorModel {
    
    func addNum (_ first:Int, _ second:Int) -> Int {
        return first + second
    }
    
    func subNum (_ first:Int, _ second:Int) -> Int {
        return first - second
    }
    
    func divNum (_ first:Int, _ second:Int) -> Int {
        return first / second
    }
    
    func multNum (_ first:Int, _ second:Int) -> Int {
        return first * second
    }
    
    func oppositeNum (_ first:Int) -> Int {
        return -first
    }
    
    func percentNum (_ first:Int, _ second:Int) -> Int {
        return first + second
    }
    
    func numberFormatter(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }
    
    func stringFormatter(string: String) -> Any {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.number(from: string)!
    }
}
