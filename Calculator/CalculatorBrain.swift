//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by 高锐 on 2017-05-25.
//  Copyright © 2017 Ray Gao. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    private var acc: Double?
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
        case AC
    }
    
    private var operations: Dictionary<String, (Opt: Operation, Priority: Int)> = [
        "AC": (Operation.AC, 0),
        "π": (Operation.constant(Double.pi), 0),
        "e": (Operation.constant(M_E), 0),
        "±": (Operation.unary( {-$0} ), 0),
        "√": (Operation.unary( {sqrt($0)} ), 0),
        "%": (Operation.unary( {$0 / 100} ), 0),
        "sin": (Operation.unary( {sin($0)} ), 0),
        "cos": (Operation.unary( {cos($0)} ), 0),
        "×": (Operation.binary( {$0 * $1} ), 2),
        "÷": (Operation.binary( {$0 / $1} ), 2),
        "+": (Operation.binary( {$0 + $1} ), 1),
        "-": (Operation.binary( {$0 - $1} ), 1),
        "=": (Operation.equal, 0)
    ]
    
    private struct PendingOperation {
        let priority: Int
        var firstOperand: Double
        let function: (Double, Double) -> Double
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    private func mergeOperation(first: PendingOperation, second: PendingOperation) -> PendingOperation {
        let newOperand = first.perform(with: second.firstOperand)
        let newOperation = PendingOperation(priority: second.priority, firstOperand: newOperand, function: second.function)
        return newOperation
    }
    
    private var pendingOperation: Array<PendingOperation?> = []
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]?.Opt {
            switch operation {
            case .AC:
                pendingOperation = []
                acc = 0
            case .constant(let const):
                acc = const
            case .unary(let function):
                if acc != nil {
                    acc = function(acc!)
                }
            case .binary(let function):
                if acc != nil {
                    let priority = operations[symbol]!.Priority
                    let operationItem = PendingOperation(priority: priority, firstOperand: acc!, function: function)
                    pendingOperation.append(operationItem)
                    acc = nil
                }
            case .equal:
                if acc != nil && !pendingOperation.isEmpty {
                    for priority in (1...2).reversed() {
                        let length = pendingOperation.count
                        if length == 0 {break}
                        for index in 0..<length {
                            let element = pendingOperation[index]
                            if element!.priority == priority && index < length-1 {
                                pendingOperation[index+1] = mergeOperation(first: element!, second: pendingOperation[index+1]!)
                                pendingOperation[index] = nil
                            } else if element!.priority == priority {
                                acc = element!.perform(with: acc!)
                                pendingOperation[index] = nil
                            }
                        }
                        pendingOperation = pendingOperation.filter({$0 != nil})
                        print(pendingOperation.count)
                    }
                    pendingOperation = []
                    //acc = pendingOperation!.perform(with: acc!)
                    //pendingOperation = nil
                }
            }
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        acc = operand
    }
    
    var result: Double? {
        get {
            return acc
        }
    }
}

