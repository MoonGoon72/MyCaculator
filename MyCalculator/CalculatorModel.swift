//
//  CalculatorModel.swift
//  MyCalculator
//
//  Created by cnu on 2023/01/26.
//

import Foundation

func chageSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1: Double,op2: Double) -> Double {
    return op1 * op2
}


class CalculatorModel: ObservableObject {
    
    @Published var displayValue:String = "0"
    
    private let buttonCodeVertical: [[String]] = [
        ["C", "±", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    private let buttonCodeHorizontal: [[String]] = [
        ["(",   ")",    "mc",   "m+",   "m-",   "mr",   "C",    "±",    "%",    "÷"],
        ["2nd", "x²",   "x³",   "xʸ",   "eˣ",   "10ˣ",  "7",    "8",    "9",    "×"],
        ["√x",  "2/x",  "3/x",  "y/x",  "ln",   "log10","4",    "5",    "6",    "−"],
        ["x!",  "sin",  "cos",  "tan",  "e",    "EE",   "1",    "2",    "3",    "+"],
        ["Rad", "sinh", "cosh", "tanh", "pi",   "Rand", "0",    "0",    ".",    "="]
    ]
    
    func getButtonCodeList() -> [[String]] {
        return buttonCodeVertical
    }
    func inputToken(input:String) {
        
        if let _ = Int(input) {
            inputDigit(input: input)
        }
        else {
            if userIsInTheMiddleOfTyping, let value =
                Double(displayValue) {
                setOperand(operand: value)
                userIsInTheMiddleOfTyping = false
            }
            performOperation(input)
            if let value = result {
                displayValue = String(value)
            }
        }
    }
    private var userIsInTheMiddleOfTyping = false
    
    private enum Operation {
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "±" : Operation.unaryOperation(chageSign),
        "%" : Operation.unaryOperation({ $0 / 100.0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "-" : Operation.binaryOperation({ $0 - $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "=" : Operation.equals,
        "C" : Operation.clear
    ]
    
    
    
    private func inputDigit(input:String) {
        if userIsInTheMiddleOfTyping {
            let textCurrentlyinDisplay = displayValue
            displayValue = textCurrentlyinDisplay + input
        } else {
            displayValue = input
            userIsInTheMiddleOfTyping = true
        }
    }
    
    private var accumulator: Double?
    
    private func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                clearOperation()
                
            }
        }
    }
    
    private func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private var result: Double? {
        get {
            return accumulator
        }
    }
    
    private func performPendingBinaryOperation() {
        if let pend = pbo, let accum = accumulator {
            accumulator = pend.perform(with: accum)
            pbo = nil
        }
    }
    
    private func clearOperation() {
        accumulator = nil
        pbo = nil
        displayValue = "0"
    }
    
    
    private var pbo: PendingBinaryOperation?
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand : Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
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
