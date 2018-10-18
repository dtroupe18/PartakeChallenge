//
//  ViewController.swift
//  PartakeChallenge
//
//  Created by Dave on 10/18/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage // This makes creating constraints in code easier
import Kingfisher // This caches the images so that we don't download them multiple times

class ViewController: UIViewController {
    
    // https://api.demo.partaketechnologies.com/api/venue?q=Club&page=2
    
    let header = Header()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundBlack
        
        view.addSubview(header)
        
    
        header.topAnchor == view.safeTopAnchor + 20
        header.horizontalAnchors == view.horizontalAnchors
        
    }
    
    

    

}

