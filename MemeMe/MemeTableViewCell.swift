//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Max Campolo on 4/19/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeTopTextLabel: UILabel!
    @IBOutlet weak var memeBottomTextLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //self.setSelected(false, animated: false)
    }
    
    // MARK: Setup
    
    func setupCellWithMeme(meme: Meme) {
        self.memeImageView.image = meme.memedImage
        self.memeTopTextLabel.text = meme.topText! as String
        self.memeBottomTextLabel.text = meme.bottomText! as String
    }
    

}
