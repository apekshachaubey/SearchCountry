//
//  DBManager.swift
//  SearchCountry
//
//  Created by cdp on 06/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataStack {
    
    static var arrCountryOfflineData = [CountryViewModel]()
    
    static var appDocDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    static var managedObjModel: NSManagedObjectModel = {
    
        let dbURL = Bundle(for: CoreDataStack.self).url(forResource: "SearchCountry", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: dbURL)!
    }()
    
    
    static var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjModel)
        let url = appDocDirectory.appendingPathComponent("DatabaseTest.sqlite")
        
        var failureReason = "Error while loading the saved app data !"
        
        let options = [NSMigratePersistentStoresAutomaticallyOption: NSNumber(value: true as Bool), NSInferMappingModelAutomaticallyOption: NSNumber(value: true as Bool)]
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
           
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Coult not initialize the app data" as AnyObject
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("Unknown error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    
    static var managedObjCxt: NSManagedObjectContext = {
        let coordinator = persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    
    
    static func getEntity<T: NSManagedObject>() -> T {
        if #available(iOS 10, *) {
            let obj = T.init(context: CoreDataStack.managedObjCxt)
            return obj
        } else {
            guard let entityDescription = NSEntityDescription.entity(forEntityName: NSStringFromClass(T.self), in: CoreDataStack.managedObjCxt) else {
                fatalError("Entity does not exist.")
            }
            let obj = T.init(entity: entityDescription, insertInto: CoreDataStack.managedObjCxt)
            return obj
        }
    }
    
    
    static func saveContext () {
        //if managedObjectContext.hasChanges {
            do {
                try managedObjCxt.save()
            } catch {

                let nserror = error as NSError
                NSLog("UnKnown error \(nserror), \(nserror.userInfo)")
                //abort()
            }
        //}
    }
    
    
    static func fetchContext ()->[CountryViewModel]{
        
    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CountryDetailTable")
    request.returnsObjectsAsFaults = false
    var tempCountryOfflineData = [CountryViewModel]()
        
        do {
            
            var objCountry = Country()
        
            var result = try managedObjCxt.fetch(request)
            for data in result as! [NSManagedObject] {
                
                objCountry.name = (data.value(forKey: "name")) as! String
                objCountry.capital = ((data.value(forKey: "capital")) as! String)
                
                objCountry.callingCode = (data.value(forKey: "callingcode")) as! String
                objCountry.region = (data.value(forKey: "region")) as! String
                objCountry.subRegion = (data.value(forKey: "subregion")) as! String
                
                objCountry.timeZone = (data.value(forKey: "timezone")) as! String
                objCountry.currencies = (data.value(forKey: "currencies")) as! String
                
                objCountry.languages = (data.value(forKey: "langauges")) as! String
                objCountry.flag = (data.value(forKey: "flag")) as! String
                objCountry.flagImage = (data.value(forKey: "flagImage")) as? NSData 
                
                var objCVM = CountryViewModel(countryModel: objCountry)
                tempCountryOfflineData.append(objCVM)

            }
        } catch {
            print(" Error occured ")
        }
    
        return tempCountryOfflineData
    }
    
}
