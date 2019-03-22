//
//  DetailViewController.swift
//  NASAmarsAPI
//
//  Created by Renato Gamboa on 6/8/18.
//  Copyright © 2018 RenatoGamboa. All rights reserved.
//

import UIKit
import Hero

class DetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var saveImage: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var image = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDropShadow()
        
        
        
        detailImageView.image = image
        

        // Do any additional setup after loading the view.
    }
    
    func setUpDropShadow() {
        navBar.layer.masksToBounds = false
        navBar.layer.shadowColor = UIColor.black.cgColor
        navBar.layer.shadowOpacity = 0.5
        navBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navBar.layer.shadowRadius = 1
        navBar.layer.shadowPath = UIBezierPath(rect: navBar.layer.bounds).cgPath
        navBar.layer.shouldRasterize = true
        navBar.layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    
    // Save Image
    @IBAction func saveImage(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(image)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        // Alert
        let motto = "Look what I found on the Martian Feed today! But, still no aliens...👽"
        let activityController = UIActivityViewController(activityItems: [motto, image], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    
}
