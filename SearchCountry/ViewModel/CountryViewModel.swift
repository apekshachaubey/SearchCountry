//
//  CountryViewModel.swift
//  SearchCountry
//
//  Created by cdp on 06/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import Foundation
import UIKit

var countryModel:[CountryViewModel] = [CountryViewModel(countryModel: defaultCountry)]

class CountryViewModel {
    
    private let countryModel: Country
    
    init(countryModel: Country)
    {
        self.countryModel = countryModel
    }
    
    public var Name: String {
        return countryModel.name
    }
    
    public var Capital: String {
        return countryModel.capital
    }
    
    public var CallingCode: String {
        return countryModel.callingCode
    }
    
    public var Region: String {
        return countryModel.region
    }
    
    public var SubRegion: String {
        return countryModel.subRegion
    }
    
    public var TimeZone: String {
        return countryModel.timeZone
    }
    
    public var Currencies: String {
        return countryModel.currencies
    }
    
    public var Langauges: String {
        return countryModel.languages
    }
    
    public var FlagURl: String {
        return countryModel.flag
    }
    
    public var FlagImage: NSData {
        return countryModel.flagImage!
    }
    
    
    // get offline data from Coredata
    class func getCountriesOffline() -> [CountryViewModel] {

        let arrCountryOfflineData = CoreDataManager.sharedManager.getCountriesOffline()
        return arrCountryOfflineData
    }
    
    // get online data from web api
    class func getCountriesOnline(jsonResponse:[[String: Any]]) ->[CountryViewModel]{
        var countryList = [CountryViewModel]()
        
        for response in jsonResponse as [Dictionary<String, AnyObject>] {
            let objCnt = Country()
            
            objCnt.name = response["name"] as! String
            objCnt.capital = response["capital"] as! String
            
            objCnt.callingCode = String(describing:(response["callingCodes"] as AnyObject))
            objCnt.region = response["region"] as! String
            objCnt.subRegion = response["subregion"] as! String
            
            objCnt.flag = response["flag"] as! String

            objCnt.timeZone = String(String(describing:(response["timezones"] as AnyObject)).filter({ !" \n\t\r".contains($0) }))
            
            //objCnt.currencies = String(describing:(anItem["currencies"] as AnyObject))
            for lang in (response["currencies"] as AnyObject) as! [[String: AnyObject]] {
                for nameCurrency in [lang] as [[String: AnyObject]] {
                    if(nameCurrency["name"] != nil){
                        if let y = nameCurrency["name"] as? String {
                            objCnt.currencies += (nameCurrency["name"] as! String ) + " "
                        } else {
                            objCnt.currencies += " "
                        }
                    }
                }
            }
            
            //objCnt.languages = String(describing:(anItem["languages"] as AnyObject))
            for lang in (response["languages"] as AnyObject) as! [[String: AnyObject]] {
                for nameLang in [lang] as [[String: AnyObject]] {
                    if(nameLang["name"] != nil){
                        objCnt.languages += (nameLang["name"] as! String ) + ", "
                    }
                }
            }
            
            let objVM = CountryViewModel(countryModel: objCnt)
            countryList.append(objVM)
        }
        
        return countryList;
    }
}

