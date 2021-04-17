//
//  LoginDelegate.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/17.
//

import Foundation

protocol LoginDelegate: class {
    func loginSuccess()
    func loginFailed(err: String)
}
