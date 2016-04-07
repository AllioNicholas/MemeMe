//
//  CollectionMeme.swift
//  MemeMe
//
//  Created by Nicholas Allio on 01/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class CollectionMeme: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved memes
        if let savedMemes = loadMemes() {
            memes += savedMemes
        }
        
        let space = CGFloat(3.0)
        let dimension = (self.view.frame.size.width - (2 * space)) / 3.0
        
        collectionViewFlowLayout.minimumInteritemSpacing = space
        collectionViewFlowLayout.minimumLineSpacing = space
        collectionViewFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            if let savedMemes = self.loadMemes() {
                self.memes = savedMemes
            }
            self.collectionView?.reloadData()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let coll = collectionView.dequeueReusableCellWithReuseIdentifier("MemeColl", forIndexPath: indexPath) as! MemeCollectionCellView
        let meme = memes[indexPath.item]
        coll.memeImage.image = meme.memedImage

        return coll
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailMeme") as! DetailMeme
        detailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // NSCoding
    func loadMemes() -> [Meme]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meme.ArchiveURL.path!) as? [Meme]
    }
}
