//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by TEJVEER SINGH on 2022-04-05.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var rightimageView: UIImageView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var messageBuble: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBuble.layer.cornerRadius = messageBuble.frame.size.height / 3
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
