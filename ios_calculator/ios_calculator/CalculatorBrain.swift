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
    private var expectingOperand = true
    private var parenthesesBalance = 0
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equal
        case AC
        case leftParenthesis
        case rightParenthesis
    }
    
    private var operations: Dictionary<String, (Opt: Operation, Priority: Int)> = [
        "AC": (Operation.AC, 0),
        "π": (Operation.constant(Double.pi), 0),
        "e": (Operation.constant(M_E), 0),
        "±": (Operation.unary( {-$0} ), 4),
        "√": (Operation.unary( {sqrt($0)} ), 4),
        "%": (Operation.unary( {$0 / 100} ), 4),
        "sin": (Operation.unary( {sin($0)} ), 4),
        "cos": (Operation.unary( {cos($0)} ), 4),
        "tan": (Operation.unary( {tan($0)} ), 4),
        "x^y": (Operation.binary( {pow($0, $1)} ), 3),
        "×": (Operation.binary( {$0 * $1} ), 2),
        "÷": (Operation.binary( {$0 / $1} ), 2),
        "+": (Operation.binary( {$0 + $1} ), 1),
        "-": (Operation.binary( {$0 - $1} ), 1),
        "=": (Operation.equal, 0),
        "(": (Operation.leftParenthesis, 0),
        ")": (Operation.rightParenthesis, 0)
    ]
    
    private struct OperationStruct {
        let priorityLevel: Int
        let unaryFunction: ((Double) -> Double)?
        let binaryFunction: ((Double, Double) -> Double)?
        func perform(first: Double, second: Double?=nil) -> Double {
            if second == nil {
                return unaryFunction!(first)
            }
            return binaryFunction!(first, second!)
        }
    }
    
    private var operandStack = Array<Double>()
    
    private var operationStack = Array<(Opt: Operation, Priority: Int)>()
    
    mutating private func applyOperation(opt: Operation) {
        switch opt {
        case .binary(let function):
            let operand2 = operandStack.popLast()
            let operand1 = operandStack.popLast()
            if operand1 != nil && operand2 != nil {
                operandStack.append(function(operand1!, operand2!))
            } else {
                print("Error: nil operand(s)")
            }
        case .unary(let function):
            let operand1 = operandStack.popLast()
            if operand1 != nil{
                operandStack.append(function(operand1!))
            } else {
                print("Error: nil operand")
            }
        default:
            print("Error: unkown operation type")
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        //if expectingOperand {return}
        if let operation = operations[symbol]?.Opt {
            let priority = operations[symbol]!.Priority
            switch operation {
            case .AC:
                operandStack = []
                operationStack = []
                acc = 0
                parenthesesBalance = 0
            case .constant(let const):
                operandStack.append(const)
                
            case .unary:
                operationStack.append(operations[symbol]!)
                print("unary")
            case .binary:
                while let temp = operationStack.last {
                    if priority > temp.Priority {break}
                    let _ = operationStack.popLast()
                    let lastOpt = temp.Opt
                    applyOperation(opt: lastOpt)
                }
                operationStack.append(operations[symbol]!)
                print("binary")
            case .leftParenthesis:
                parenthesesBalance -= 1
                operationStack.append(operations[symbol]!)
                print("leftParenthesis")
            case .rightParenthesis:
                parenthesesBalance += 1
                while true {
                    let temp = operationStack.popLast()
                    if temp == nil {
                        print("Error: unmatched parentheses")
                        break
                    }
                    let lastOpt = temp!.Opt
                    var flag = false
                    switch lastOpt {
                    case .leftParenthesis:
                        flag = true
                        break
                    default:
                        applyOperation(opt: lastOpt)
                    }
                    if flag {break}
                }
                print("rightParenthesis")
            case .equal:
                if parenthesesBalance != 0 {
                    break
                }
                while let temp = operationStack.popLast() {
                    let lastOpt = temp.Opt
                    applyOperation(opt: lastOpt)
                }
                acc = operandStack.popLast() ?? 0
                print("Result is: ")
                print(acc!)
            }
            expectingOperand = true
        }
    }
    
    mutating func setOperand(_ operand: Double?) {
        if let num = operand {
            operandStack.append(num)
            print("number")
            return
        }
        print("nil operand")
    }
    
    var result: Double? {
        get {
            return acc
        }
    }
}

