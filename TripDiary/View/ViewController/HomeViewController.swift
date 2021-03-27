//
//  HomeViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let travelList: [HomeDataModel] = [
        HomeDataModel(locateName: "홍천", travelPeriod: "7/9 - AM 08:00", travelImage: #imageLiteral(resourceName: "yeongwol")),
        HomeDataModel(locateName: "남이섬", travelPeriod: "7/9 - AM 10:00", travelImage: #imageLiteral(resourceName: "yeosu")),
        HomeDataModel(locateName: "여수", travelPeriod: "7/9 - PM 12:00", travelImage: #imageLiteral(resourceName: "yeosu")),
        HomeDataModel(locateName: "영월", travelPeriod: "7/9 - AM 08:00", travelImage: #imageLiteral(resourceName: "nami_island"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return travelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myTravel", for: indexPath) as? HomeViewControllerCell else { return UITableViewCell() }
        
        cell.locateName.text = travelList[indexPath.row].locateName
        cell.travelPeriod.text = travelList[indexPath.row].travelPeriod
        
        cell.travelPicture.sizeToFit()
        cell.travelPicture.image = travelList[indexPath.row].travelImage
        cell.travelPicture.layer.cornerRadius = 15
        return cell
    }
    
}

class HomeViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var locateName: UILabel!
    @IBOutlet weak var travelPeriod: UILabel!
    @IBOutlet weak var travelPicture: UIImageView!
    
}
