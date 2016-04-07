//
//  Meme.swift
//  MemeMe
//
//  Created by Nicholas Allio on 26/03/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class Meme: NSObject, NSCoding {
    
    var topText: String
    var image: UIImage
    var bottomText: String
    
    // Types
    struct PropertyKey {
        static let topTextKey = "toptext"
        static let imageKey = "image"
        static let bottomTextKey = "bottomtext"
    }
    
    // Archiving paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("memes")
    
    init?(topText: String, image: UIImage?, bottomText: String) {
        self.topText = topText
        self.image = image!
        self.bottomText = bottomText
        
        super.init()
    }
    
    // NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(topText, forKey: PropertyKey.topTextKey)
        aCoder.encodeObject(image, forKey: PropertyKey.imageKey)
        aCoder.encodeObject(bottomText, forKey: PropertyKey.bottomTextKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let topText = aDecoder.decodeObjectForKey(PropertyKey.topTextKey) as! String
        
        let image = aDecoder.decodeObjectForKey(PropertyKey.imageKey) as! UIImage
        
        let bottomText = aDecoder.decodeObjectForKey(PropertyKey.bottomTextKey) as! String
        
        // Must call designated initializer.
        self.init(topText: topText, image: image, bottomText: bottomText)
    }
}


