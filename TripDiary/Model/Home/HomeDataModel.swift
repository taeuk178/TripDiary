//
//  HomeDataModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/27.
//

import UIKit

struct HomeParameterModel: Codable {
    let useridx: String
}

// API 통신 모델
struct HomeTourlistModel: Codable {
    
    let data: TourListDataModel?
    let success: Bool
    let message: String
}

// 통신모델 안에 데이터 모델
struct TourListDataModel: Codable {
    let useridx: String
    let tourlist: [TourListDataArrayModel]
}

// 데이터 모델안에 List배열
struct TourListDataArrayModel: Codable {
    let tourimg: String
    let tourspotname: String
    let tourbegindate: String
    let tourbegintime: String
    let tourhour: String
    
    
    var tourTime: String {
        return "\(tourbegindate)\(tourbegintime)"
    }
}

struct HomeDataModel {
    
    let locateName: String
    let travelPeriod: String
    let travelImage: UIImage
    
}
