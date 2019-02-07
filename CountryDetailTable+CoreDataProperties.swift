//
//  CountryDetailTable+CoreDataProperties.swift
//  
//
//  Created by cdp on 06/02/19.
//
//

import Foundation
import CoreData


extension CountryDetailTable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountryDetailTable> {
        return NSFetchRequest<CountryDetailTable>(entityName: "CountryDetailTable")
    }

    @NSManaged public var callingcode: String?
    @NSManaged public var capital: String?
    @NSManaged public var currencies: String?
    @NSManaged public var flagImage: NSData?
    @NSManaged public var langauges: String?
    @NSManaged public var name: String?
    @NSManaged public var region: String?
    @NSManaged public var subregion: String?
    @NSManaged public var timezone: String?
    @NSManaged public var flag: String?

}
