//
//  SignInModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/17.
//

import Foundation

// 로그인 API보낼 모델

struct LoginModel: Codable {
    let email: String
    let password: String
}

// 로그인시 데이터 받아오는 모델
struct SignInModel: Codable {
    let success: Bool
    let data: SignInSuccessModel?
    let message: String
}

// 로그인시 데이터 받아오는 모델의 상세 데이터
struct SignInSuccessModel: Codable {
    let token: String
    let refreshToken: String
    let email: String
    let useridx: String
    let nickname: String
}
