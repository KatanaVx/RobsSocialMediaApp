//
//  ABetterSquareButton.swift
//  SocialMediaAppRob
//
//  Created by Roberto Cruz Quesada on 12/3/16.
//  Copyright © 2016 Roberto Cruz Quesada. All rights reserved.
//

import UIKit

class ABetterSquareButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
     
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.9
        layer.shadowRadius = 3.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
    
}
