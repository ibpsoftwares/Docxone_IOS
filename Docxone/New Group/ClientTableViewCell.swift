//
//  ClientTableViewCell.swift
//  Docxone
//
//  Created by Apple on 09/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

     @IBOutlet var lblName: UILabel!
     @IBOutlet var imgBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
