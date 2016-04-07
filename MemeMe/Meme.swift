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
    var memedImage: UIImage
    var origImage: UIImage
    var bottomText: String
    
    // Types
    struct PropertyKey {
        static let topTextKey = "toptext"
        static let memedImageKey = "memedImage"
        static let origImage = "origImage"
        static let bottomTextKey = "bottomtext"
    }
    
    // Archiving paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("memes")
    
    init?(topText: String, memedImage: UIImage?, origImage: UIImage?, bottomText: String) {
        self.topText = topText
        self.memedImage = memedImage!
        self.origImage = origImage!
        self.bottomText = bottomText
        
        super.init()
    }
    
    // NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(topText, forKey: PropertyKey.topTextKey)
        aCoder.encodeObject(memedImage, forKey: PropertyKey.memedImageKey)
        aCoder.encodeObject(origImage, forKey: PropertyKey.origImage)
        aCoder.encodeObject(bottomText, forKey: PropertyKey.bottomTextKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let topText = aDecoder.decodeObjectForKey(PropertyKey.topTextKey) as! String
        
        let memedImage = aDecoder.decodeObjectForKey(PropertyKey.memedImageKey) as! UIImage
        
        let origImage = aDecoder.decodeObjectForKey(PropertyKey.origImage) as! UIImage
        
        let bottomText = aDecoder.decodeObjectForKey(PropertyKey.bottomTextKey) as! String
        
        // Must call designated initializer.
        self.init(topText: topText, memedImage: memedImage, origImage: origImage, bottomText: bottomText)
    }
}


