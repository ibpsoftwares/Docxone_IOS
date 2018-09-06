//
//  SearchResultTableViewCell.swift
//  Docxone
//
//  Created by Apple on 16/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {

     @IBOutlet var lblName: UILabel!
     @IBOutlet var lblModifyBy: UILabel!
     @IBOutlet var lblUrl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
