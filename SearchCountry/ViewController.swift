//
//  ViewController.swift
//  SearchCountry
//
//  Created by cdp on 02/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            print("Internet Connection not Available!")
        }
        
    }


}

