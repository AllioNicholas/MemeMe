//
//  DetailMeme.swift
//  MemeMe
//
//  Created by Nicholas Allio on 01/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class DetailMeme: UIViewController {
    
    var meme: Meme?
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        memeImage.image = meme?.image
    }
}
