//
//  HomeAPIManager.swift
//  TripDiary
//
//  Created by taeuk on 2021/04/17.
//

import Alamofire

struct HomeAPIManager {
    
    let header: HTTPHeaders = [.contentType("application/json")]
    
    func requestHomeTourList(completion: @escaping (_ result: [TourListDataArrayModel]) -> Void) {
        
        let parameterModel = HomeParameterModel(useridx: "1")
        let url = Constants.apiBaseUrl+Constants.tourlistUrl
        
        AF.request(url, method: .post, parameters: parameterModel, encoder: JSONParameterEncoder.default, headers: header)
            .response { response in
                guard let result = try? JSONDecoder().decode(HomeTourlistModel.self, from: response.data ?? Data()) else { return }
                guard response.data != nil else { return }
                completion(result.data!.tourlist)
            }
    }
}
