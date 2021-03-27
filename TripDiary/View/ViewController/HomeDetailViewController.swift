//
//  HomeDetailViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/27.
//

import UIKit

class HomeDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeDetailViewController: UITableViewDelegate {
    
}

extension HomeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Detail", for: indexPath) as? HomeDetailViewControllerCell else { return UITableViewCell() }
        
        return cell
    }
}

class HomeDetailViewControllerCell: UITableViewCell {
    
}
