//
//  ListMeme.swift
//  MemeMe
//
//  Created by Nicholas Allio on 01/04/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import Foundation
import UIKit

class ListMeme: UITableViewController {
    
    var memes = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved memes
        if let savedMemes = loadMemes() {
            memes += savedMemes
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        dispatch_async(dispatch_get_main_queue()) {
            if let savedMemes = self.loadMemes() {
                self.memes = savedMemes
            }
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextVC = storyboard?.instantiateViewControllerWithIdentifier("DetailMeme") as! DetailMeme
        nextVC.meme = memes[indexPath.row]
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")! as UITableViewCell
        cell.textLabel?.text = "\(memes[indexPath.row].topText) \(memes[indexPath.row].bottomText)"
        cell.imageView?.image = memes[indexPath.row].memedImage
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    // NSCoding
    func loadMemes() -> [Meme]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Meme.ArchiveURL.path!) as? [Meme]
    }
}
