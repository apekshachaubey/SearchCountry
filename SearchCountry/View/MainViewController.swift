import UIKit
import SVGKit
import CoreData


class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView : UITableView! 
    @IBOutlet weak var searchBar : UISearchBar!
    
    var dataSource = CountryViewModel.getCountriesOffline()

    var filteredCountry = [CountryViewModel]()
    var arrCountryViewModel = [CountryViewModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            tableView.isHidden = true;
        }
        else{
            tableView.isHidden = false;
        }
    }
}



extension MainViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if Reachability.isConnectedToNetwork() {
            return filteredCountry.count
        }
        else{
            return dataSource.count
        }
}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell") as! CountryCell
        
        if Reachability.isConnectedToNetwork() {
            cell.lbl.text = filteredCountry[indexPath.row].Name

        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            if let url = NSURL(string: self!.filteredCountry[indexPath.row].FlagURl){
                    if let data = NSData(contentsOf: url as URL) {

                        DispatchQueue.main.async {
                            let flagImage: SVGKImage = SVGKImage(data: data as Data)
                            cell.imgFlag.image = flagImage.uiImage
                        }
                    }
                }
            }
        }
        else {
            
            if(dataSource.count == 0){
                
                cell.lbl.text = ""
                cell.imgFlag.image = UIImage(named: "defaultFlag")!
            }
            else {
                
                cell.lbl.text = dataSource[indexPath.row].Name
                cell.imgFlag.image = UIImage(data:dataSource[indexPath.row].FlagImage as Data,scale:1.0)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "countryDetailSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if Reachability.isConnectedToNetwork() {
            
            if let countryCell = segue.destination as? CountryDetailViewController {
                countryCell.countryViewModel = filteredCountry[(tableView.indexPathForSelectedRow?.row)!]
                
                let backItem = UIBarButtonItem()
                backItem.title = "          About " + (countryCell.countryViewModel?.Name)!
                backItem.tintColor = UIColor.init(red: 64/255, green: 192/255, blue: 151/255, alpha: 1.0)
                navigationItem.backBarButtonItem = backItem
            }
        }
        else {
            
            if let countryCell = segue.destination as? CountryDetailViewController {
                countryCell.countryViewModel = dataSource[(tableView.indexPathForSelectedRow?.row)!]
            }
        }
    }
}



extension MainViewController : UISearchBarDelegate{
    
func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = false
        
        if Reachability.isConnectedToNetwork() {
            
            countryWebAPI { jsonResponse, error in
                guard let jsonResponse = jsonResponse, error == nil else {
                    print("Error: ", error ?? "Json response is Incorrect")
                    return
            }
            
            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                  return
            }
            
            self.arrCountryViewModel = CountryViewModel.getCountriesOnline(jsonResponse: jsonArray)

            DispatchQueue.main.async {
                self.filteredCountry = self.arrCountryViewModel.filter({$0.Name.prefix(searchText.count) == searchText})
                self.tableView.reloadData()
            }
          }
        }
        else {
            
            let tempData = CountryViewModel.getCountriesOffline()
            self.dataSource = tempData.filter({$0.Name.prefix(searchText.count) == searchText})
            self.tableView.reloadData()
        }
    }
    
    
func countryWebAPI (completionHandler: @escaping ([[String: Any]]?, Error?) -> Void) {
        
        let urlString = URL(string: "https://restcountries.eu/rest/v2/all")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else {
                    
                    completionHandler(nil, error)
                    return
                }

                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with:
                        data)
                    
                    completionHandler(jsonResponse as? [[String: Any]], nil)
                } catch let parsingError {
                    completionHandler(nil, parsingError)
                }
            }
            task.resume()
        }
    }
}

