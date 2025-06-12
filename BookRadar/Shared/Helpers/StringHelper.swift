//
//  StringHelper.swift
//  BookRadar
//
//  Created by Agata Przykaza on 12/06/2025.
//

func bookCountText(for count: Int) -> String {
    switch count {
    case 0:
        return "Brak książek"
    case 1:
        return "1 książka"
    case 2, 3, 4:
        return "\(count) książki"
    case 5...20:
        return "\(count) książek"
    default:
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 19 {
            return "\(count) książek"
        }
        
        switch lastDigit {
        case 1:
            return "\(count) książka"
        case 2, 3, 4:
            return "\(count) książki"
        default:
            return "\(count) książek"
        }
    }
}

// Rozszerzenie Int
extension Int {
    var bookText: String {
        return bookCountText(for: self)
    }
}
