//
//  ViewController.swift
//  MemeMe
//
//  Created by Nicholas Allio on 22/03/16.
//  Copyright © 2016 Nicholas Allio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func pickImagePhotoLibrary(sender: AnyObject) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    @IBAction func pickImageCamera(sender: AnyObject) {
        let imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        imagePickerViewController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePickerViewController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            imagePickerView.image = image
        }
    }

}

