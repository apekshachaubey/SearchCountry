//
//  CountryCell.swift
//  SearchCountry
//
//  Created by cdp on 02/02/19.
//  Copyright © 2019 cdp. All rights reserved.
//

import UIKit

class CountryCell: UITableViewCell {
    
    @IBOutlet weak var lbl : UILabel!
    @IBOutlet weak var imgFlag: UIImageView!
    @IBOutlet weak var webVw: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
