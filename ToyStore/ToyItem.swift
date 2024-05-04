//
//  ToyItem.swift
//  ToyStore
//
//  Created by Julio Pascoato on 03/05/24.
//

import Foundation

struct ToyItem {
    let name: String
    let donor: String
    let address: String
    let phoneNumber: String
    let condition: Int
    let id: String
    
    var toyCondition: String{
        switch condition {
        case 0:
            return "Novo"
        case 1:
            return "Usado"
        default:
            return "Precisa de reparo"
        }
    }
}


    
    
    
