//
//  HomeViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/24.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    var tourListData: [TourListDataArrayModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        
        let homeApi = HomeAPIManager()
        homeApi.requestHomeTourList { [weak self] result in
            self?.tourListData = result
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    

}

// MARK: - Delegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

// MARK: - DataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tourListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myTravel", for: indexPath) as? HomeViewControllerCell else { return UITableViewCell() }
        
        cell.locateName.text = tourListData[indexPath.row].tourspotname
        cell.travelPeriod.text = tourListData[indexPath.row].tourTime
        
        cell.travelPicture.sizeToFit()
        cell.travelPicture.setImageUrl(tourListData[indexPath.row].tourimg)
        cell.travelPicture.layer.cornerRadius = 15
        
        return cell
    }
    
}

class HomeViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var locateName: UILabel!
    @IBOutlet weak var travelPeriod: UILabel!
    @IBOutlet weak var travelPicture: UIImageView!
    
}
