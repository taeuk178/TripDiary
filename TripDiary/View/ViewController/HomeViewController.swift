//
//  HomeViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/24.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myTravel", for: indexPath) as? HomeViewControllerCell else { return UITableViewCell() }
        cell.locateName.text = "남이섬"
        cell.travelPeriod.text = "8-20 PM 02:00"
        
        cell.travelPicture.sizeToFit()
        cell.travelPicture.image = UIImage(named: "yeosu")
        cell.travelPicture.layer.cornerRadius = 15
        return cell
    }
    
}

class HomeViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var locateName: UILabel!
    @IBOutlet weak var travelPeriod: UILabel!
    @IBOutlet weak var travelPicture: UIImageView!
    
}
