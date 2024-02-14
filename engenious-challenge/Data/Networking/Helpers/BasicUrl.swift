//
//  BasicUrl.swift
//  engenious-challenge
//
//  Created by Serhii Semenov on 14.02.2024.
//

import Foundation

enum BasicURL {
    case mainEnv
    
    var basicURL: String {
        switch self {
        case .mainEnv:
            return "https://api.github.com"
        }
    }
}
