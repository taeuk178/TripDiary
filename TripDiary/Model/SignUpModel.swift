//
//  SignUpModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import Foundation

struct SignUpModel: Codable {
    
    let email: String
    let password: String
    let provider: String
    let token: String
    let nickname: String
}
