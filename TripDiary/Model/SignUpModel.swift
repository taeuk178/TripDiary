//
//  SignUpModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import Foundation
// 회원가입시 필요 모델
struct SignUpModel: Codable {
    
    let email: String
    let password: String
    let provider: String
    let token: String
    let nickname: String
}

// 회원가입하고 데이터 받아오는 모델
struct GetSignUpModel: Codable {
    
    let success: Bool
    let data: GetSignUpDataModel
    let message: String
}
// 데이터의 데이터모델
struct GetSignUpDataModel: Codable {
    let email: String
    let useridx: String
}
