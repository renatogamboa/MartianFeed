//
//  APODViewController.swift
//  NASAmarsAPI
//
//  Created by Renato Gamboa on 7/13/18.
//  Copyright © 2018 RenatoGamboa. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class APODViewController: UIViewController {

    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var saveButton: UINavigationBar!
    @IBOutlet weak var loadStackView: UIStackView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var infoToggle = false
    
    var image = UIImage()
    
    // Description of Photo
    var info = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isHidden = true
        navBar.isHidden = false
        navBar.layer.zPosition = 3
        imageView.layer.zPosition = -1
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor.black
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)

        
        infoButton.isEnabled = false
        textField.isHidden = true
        loadStackView.isHidden = false
        indicatorView.startAnimating()
        setUpDropShadow()
        
        parseJson()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    func setUpDropShadow2() {
        let x = textField.layer
        
        x.masksToBounds = false
        x.shadowColor = UIColor.red.cgColor
        x.shadowOpacity = 1
        x.shadowOffset = CGSize(width: -1, height: 1)
        x.shadowRadius = 5
        x.shadowPath = UIBezierPath(rect: textField.layer.bounds).cgPath
        x.shouldRasterize = true
        x.rasterizationScale = UIScreen.main.scale
        
    }
    
    // Save Image
    @IBAction func saveImage(_ sender: Any) {
        let imageData = UIImagePNGRepresentation(imageView.image!)
        let compressedImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func viewInfo(_ sender: Any) {
        if infoToggle == false {
        textField.isHidden = false
        blurView.isHidden = false
        infoToggle = true
        textField.text = info
        textField.flashScrollIndicators()
        } else if infoToggle == true{
            textField.isHidden = true
            blurView.isHidden = true
            infoToggle = false
        }
    }
    
    // Parse Through Remote JSON File using Alamofire + SwiftJSON
    func parseJson() {
        //Link for API
        //"https://api.nasa.gov/planetary/apod?api_key=7q24HdPugb4ioOd2RntTEaudSDNlVVBuLi8FgJzP"
        
        // Gets current date from year
        //let month = calendar.component(.month, from: date)
        //let day = calendar.component(.day, from: date)
        
        // Alamofire request
        Alamofire.request("https://api.nasa.gov/planetary/apod?api_key=7q24HdPugb4ioOd2RntTEaudSDNlVVBuLi8FgJzP").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                // Get JSON Variables
                let photoURL = swiftyJsonVar["url"].string
                let photoDescription = swiftyJsonVar["explanation"].string
                
                // Test Print
                print(photoURL)
                print(photoDescription)
                
                let url = URL(string: photoURL!)
                self.info = photoDescription!
                
                DispatchQueue.main.async {
                    self.imageView.af_setImage(withURL: url!)
                }
                //self.image = self.imageView.image!
                self.loadStackView.isHidden = true
                self.saveButton.isHidden = false
                self.infoButton.isEnabled = true
                
            }
        }
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        // Alert
        let motto = "Check out the astronomy picture of the day!"
        let activityController = UIActivityViewController(activityItems: [motto, imageView.image], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    

}
/*
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
 */
