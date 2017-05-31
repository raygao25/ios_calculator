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
    
    var displayValue: Double {
        get {
            return Double(operand)!
        }
        set {
            let mod = newValue.truncatingRemainder(dividingBy: 1)
            if mod == 0 {
                operand = String(Int(newValue))
                display.text = operand
            } else {
                operand = String(newValue)
                display.text = operand
            }
        }
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if typing_number {
            typing = true
            let Operation = sender.currentTitle!
            display.text = display.text! + Operation
            brain.setOperand(displayValue)
            operand = ""
            typing_number = false
        }
        if let symbol = sender.currentTitle {
            brain.performOperation(symbol)
        }
        if let result = brain.result {
            displayValue = result
            typing_number = true
            typing = false
        }
    }
}

