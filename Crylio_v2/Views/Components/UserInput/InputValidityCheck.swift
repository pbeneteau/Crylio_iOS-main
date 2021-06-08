//
//  InputChecker.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 28/05/2021.
//

import Foundation


func checkInputValidity(of inputString: String, inputType: UserInput.InputType) -> Bool {
    
    switch inputType {
    case .text:
        return true
    case .amount:
        if let amount = Float(inputString) {
            return amount.sign == .plus
        }
    case .price:
        if let price = Float(inputString) {
            return price.sign == .plus
        }
    case .date:
        return true
    case .multipleChoicePrice:
        if let price = Float(inputString)  {
            return price.sign == .plus
        }
    case .alphabetOnly:
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z\\s]+", options: [])
        let range = regex.rangeOfFirstMatch(in: inputString, options: [], range: NSRange(location: 0, length: inputString.count))
        return range.length == inputString.count
    }
    return false
}
