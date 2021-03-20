//
//  MainViewController.swift
//  TripDiary
//
//  Created by taeuk on 2021/03/20.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.naviGreenColor
        
        navigationSetting()
    }

    func navigationSetting(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

