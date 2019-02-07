import UIKit
import CoreData
import SVGKit


class CountryDetailViewController: UIViewController {

    @IBOutlet weak var lblView: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var btnSaveCountry: UIButton!
    
    var countryViewModel: CountryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // settings for UI Changes
        tableView.tableFooterView = UIView(frame: .zero)
        btnSaveCountry.layer.borderColor = UIColor(red: 0.0/255.0, green: 175.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        btnSaveCountry.layer.borderWidth = 1.0
        
        
        if Reachability.isConnectedToNetwork() {
            btnSaveCountry.isHidden = false
            
                    // to load the flag image
                    DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                        if let url = NSURL(string: (self!.countryViewModel?.FlagURl)!){
                            if let data = NSData(contentsOf: url as URL) {
            
                                DispatchQueue.main.async {
                                    let flagImage: SVGKImage = SVGKImage(data: data as Data)
                                    self!.imgFlag.image = flagImage.uiImage
                                }
                            }
                        }
                    }
        }
        else{
            
            btnSaveCountry.isHidden = true
            self.imgFlag.image  = UIImage(data:countryViewModel?.FlagImage as! Data,scale:1.0)
        }
    }

    // method for saving country details
    @IBAction func btnSaveCountry(_ sender: Any) {
        
        CoreDataManager.sharedManager.saveCountry(objCountryVM: countryViewModel!,flag :(self.imgFlag.image?.pngData() as Data!))
    }
}



extension CountryDetailViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryDetailCell") as! CountryDetailCell
        
        switch indexPath.row {
        case 0:
            cell.lblContent.text = "Country : " + (countryViewModel?.Name)!
        case 1:
             cell.lblContent.text = "Capital : " + (countryViewModel?.Capital)!
        case 2:
             cell.lblContent.text = "Region : " + (countryViewModel?.Region)!
        case 3:
            cell.lblContent.text = "Sub-Region : " + (countryViewModel?.SubRegion)!
        case 4:
            cell.lblContent.text = "Timezone : " + (countryViewModel?.TimeZone)!
        case 5:
            cell.lblContent.text = "Currencies : " + (countryViewModel?.Currencies)!
        case 6:
            cell.lblContent.text = "Langauges : " + (countryViewModel?.Langauges)!
        default:
            print("Otherwise, do something else.")
        }
         return cell
    }
}
