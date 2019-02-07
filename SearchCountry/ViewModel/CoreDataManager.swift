import Foundation
import CoreData
import UIKit

class CoreDataManager {

    static let sharedManager = CoreDataManager()
    static var arrCountryOfflineData = [CountryViewModel]()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SearchCountry")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unknown Error ..")
            }
        })
        return container
    }()
    
    
    func saveCountry(objCountryVM: CountryViewModel,flag : Data){
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "CountryDetailTable",
                                                in: managedContext)!
        let country = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        country.setValue(objCountryVM.Name, forKeyPath: "name")
        country.setValue(objCountryVM.Capital, forKeyPath: "capital")
        
        country.setValue(objCountryVM.CallingCode, forKeyPath: "callingcode")
        country.setValue(objCountryVM.Region, forKeyPath: "region")
        country.setValue(objCountryVM.SubRegion, forKeyPath: "subregion")
        
        country.setValue(objCountryVM.TimeZone, forKeyPath: "timezone")
        country.setValue(objCountryVM.Currencies, forKeyPath: "currencies")
        
        country.setValue(objCountryVM.FlagURl, forKeyPath: "flag")
        country.setValue(objCountryVM.Langauges, forKeyPath: "langauges")
        country.setValue(flag, forKeyPath: "flagImage")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error while saving data")
        }
    }
    
    
     func getCountriesOffline() -> [CountryViewModel]{
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CountryDetailTable")
        
        var tempCountryOfflineData:[CountryViewModel] =  [CountryViewModel]()
        
        do {
            
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                
                let objCountry = Country()
                
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
                
                let objCVM = CountryViewModel(countryModel: objCountry)
                tempCountryOfflineData.append(objCVM)
                
            }
        } catch {
            print("Error while fetching data")
        }
        
        return tempCountryOfflineData
    }
    
}
