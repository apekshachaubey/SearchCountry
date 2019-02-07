//
//  Country.swift
//  SearchCountry
//
//  Created by cdp on 02/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import Foundation
import UIKit

class Country {
    
    var name :String = ""
    var capital:String = ""
    
    var callingCode :String = ""
    var region:String = ""
    var subRegion :String = ""

    var timeZone :String = ""
    var currencies:String = ""
    
    var languages:String = ""
    var flag:String = "'"
    
    var flagImage:NSData?
    
}

let defaultCountry = Country()
