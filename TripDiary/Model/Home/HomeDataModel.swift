//
//  HomeDataModel.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/27.
//

import UIKit

// API 통신 모델

struct HomeTourlistModel {
    
    let data: TourListDataModel
    let success: Bool
    let message: String
}

// 통신모델 안에 데이터 모델
struct TourListDataModel {
    let useridx: String
    let tourlist: [TourListDataArrayModel]
}

// 데이터 모델안에 List배열
struct TourListDataArrayModel {
    let tourimg: String
    let tourspotname: String
    let tourbegindate: String
    let tourbegintime: String
    let tourhour: String
}

struct HomeDataModel {
    
    let locateName: String
    let travelPeriod: String
    let travelImage: UIImage
    
}
