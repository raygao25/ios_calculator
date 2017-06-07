//
//  ViewController.swift
//  Calculator
//
//  Created by 高锐 on 2017-05-24.
//  Copyright © 2017 Ray Gao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var operand = ""
    var typing = false
    var typing_number = false
    
    private var brain = CalculatorBrain()
    
    var displayValue: Double? {
        get {
            return Double(operand)
        }
        set {
            let mod = newValue!.truncatingRemainder(dividingBy: 1)
            if mod == 0 {
                operand = String(format: "%g", newValue!)
            } else {
                operand = String(newValue!)
            }
            display.text = operand
        }
    }
    
    @IBAction func NumberButton(_ sender: UIButton) {
        let digit = sender.currentTitle!
        typing_number = true
        if typing {
            display.text = display.text! + digit
            operand = operand + digit
        } else {
            display.text = digit
            operand = digit
            typing = true
        }
    }
    
    @IBAction func ConstantButton(_ sender: UIButton) {
        let number = sender.currentTitle!
        typing_number = true
        if typing {
            display.text = display.text! + number
            operand = operand + number
        } else {
            display.text = number
            operand = number
            typing = true
        }
        brain.performOperation(number)
    }
    
    @IBAction func calculateResult(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if operand != "" {
            brain.setOperand(displayValue)
            operand = ""
        }
        brain.performOperation(operation)
        if let result = brain.result {
            displayValue = result
            typing_number = true
            typing = false
        }
    }
    
    @IBAction func performParenthesis(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if typing {
            if operation == ")" && typing_number {
                if operand != "" {
                    brain.setOperand(displayValue)
                    operand = ""
                }
                brain.performOperation(operation)
                display.text = display.text! + operation
            } else if operation == "(" {
                brain.performOperation(operation)
                display.text = display.text! + operation
            }
        } else {
            if operation == "(" {
                brain.performOperation(operation)
                display.text = operation
                typing = true
            }
        }
    }
    
    @IBAction func performAC(_ sender: UIButton) {
        operand = ""
        let operation = sender.currentTitle!
        brain.performOperation(operation)
        if let result = brain.result {
            displayValue = result
            typing_number = false
            typing = false
        }
    }
    
    @IBAction func performUnaryOperation(_ sender: UIButton) {
        let operation = sender.currentTitle!
        if !typing_number {
            if typing {
                display.text = display.text! + operation
                display.text = display.text! + "("
                
            } else {
                display.text = operation
                display.text = display.text! + "("
                typing = true
            }
            brain.performOperation(operation)
            brain.performOperation("(")
            typing_number = true
        }
    }
    
    @IBAction func performBinaryOperation(_ sender: UIButton) {
        if typing_number {
            typing = true
            let Operation = sender.currentTitle!
            if Operation == "x^y" {
                display.text = display.text! + "^"
            } else {
                display.text = display.text! + Operation
            }
            if operand != "" {
                brain.setOperand(displayValue)
                operand = ""
            }
            typing_number = false
            
            brain.performOperation(Operation)
        }
        
    }
}

