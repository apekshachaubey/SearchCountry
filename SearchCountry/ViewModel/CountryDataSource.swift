//
//  CountryDataSource.swift
//  SearchCountry
//
//  Created by cdp on 02/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CountryDataSource{
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //let context = appDelegate.persistentContainer.viewContext
    
    class func getCountries() -> [String]{
        
        let countryNames = ["Belgium","Bulgaria","Bahrain","Bahamas","Belarus","Atlanta","Cuba","Denmark"]
        return countryNames;
    }
    
    class func getCountriesOnline(jsonResponse:[[String: Any]]) ->[CountryViewModel]{
        let countryList = [CountryViewModel]()
        
        for cnt in jsonResponse {
            var objCnt = Country()
            
            
            for (key,value) in cnt {
                if(key == "name"){
                    objCnt.name = value as! String
                }
                
                if(key == "capital"){
                    objCnt.capital = value as! String
                }
                
                if(key == "flag"){
                    objCnt.flag = value as! String
                }
            }
           // var objVM = CountryViewModel(countryModel: objCnt)
            //self.arrCountryVM.append(objVM)
            //self.arrCountry.append(objCnt)
        }
        
        
        return countryList;
        
    }
}
