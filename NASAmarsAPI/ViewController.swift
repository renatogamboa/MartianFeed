//
//  ViewController.swift
//  NASAmarsAPI
//
//  Created by Renato Gamboa on 6/6/18.
//  Copyright © 2018 RenatoGamboa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireImage

// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

class ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var APODBannerView: UIView!
    @IBOutlet weak var LoadingStackView: UIStackView!
    
    
    
    // MARK: - Properties
    
    let images = [#imageLiteral(resourceName: "image-1"),#imageLiteral(resourceName: "image-2"),#imageLiteral(resourceName: "image-3"),#imageLiteral(resourceName: "image-4"),#imageLiteral(resourceName: "image-5"),#imageLiteral(resourceName: "image-6"),#imageLiteral(resourceName: "image-7")]
    // Array of any object
    var arr = [String]()
    var jsonLinks = [Any]()
    var roverImages = [UIImage]()
    var popImage: Image?
    
    // Image struct array
    var imageIDs = [UIImage]()
    
    // Image to pass
    var imageToPass: String!
    
    // Array of random sizes
    var randomSize = [200,300,350,250,400]
    
    //Data
    let date = Date()
    let calendar = Calendar.current
    let months = ["Jan","Feb","Mar","Apr","May ","June","July","Aug.","Sept.","Oct.","Nov.","Dec."]
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        startIndicator()
        // Do any additional setup after loading the view, typically from a nib.
        //print("Test")
        self.setUpLabel()
        self.parseJson()

        print(date)
        
        
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    

    // Parse Through Remote JSON File using Alamofire + SwiftJSON
    func parseJson() {
        //Link for API
        //"https://images-api.nasa.gov/search?q=mars"
        //"https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2018-6-5&api_key="
        
        // Gets current date from year
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let apiKey = "<API KEY HERE>"
        
        // Alamofire request
        Alamofire.request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?earth_date=2018-\(month)-\(day)&api_key=\(apiKey)").responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                let items = swiftyJsonVar["photos"]
                
                for (_,item) in items {
                    var x = item["img_src"].stringValue
                    //print(item["img_src"].stringValue)
                    self.arr.append(x)
                   // self.getImages(imageURL: x)
                }
                
                if self.arr.count > 0 {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func setUpLabel(){
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        self.dateLabel.text = "\(months[month - 1]) \(day)"
        self.dateLabel.adjustsFontSizeToFitWidth = true
        self.labelView.layer.zPosition = 2
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailSegue" {
            print("HI")
            
            let indexPath = collectionView.indexPath(for: sender as! UICollectionViewCell)
            
            let collectionCell = collectionView.cellForItem(at: indexPath!) as! PhotoCell
            
            let textToPass = collectionCell.imageView.image
            
            let detailVC = segue.destination as? DetailViewController
            detailVC?.image = textToPass!
            
            print("WHAT")
        }
        
        /*
         guard let indexPath = sender as? IndexPath else { return }
         
         let collectionCell = collectionView.cellForItem(at: indexPath) as! PhotoCell
         let textToPass = collectionCell.imageView.image
         
         let detailVC = segue.destination as? DetailViewController
         detailVC?.image = textToPass!
         */
    }
    
    // Indicator view
    func startIndicator(){
        //activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        //activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        //view.addSubview(activityIndicator)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func stopIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }

}

// MARK: - Flow layout delegate

extension ViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        // Return random height
        let randomIndex = Int(arc4random_uniform(UInt32(randomSize.count)))
        return CGFloat(randomSize[randomIndex])
    }
    
     // MARK: - Navigation

}



// MARK: Data Source

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        
        let maskLayer = CAGradientLayer()
        maskLayer.frame = cell.bounds
        maskLayer.shadowRadius = 5
        maskLayer.shadowPath = CGPath(roundedRect: cell.bounds.insetBy(dx: 5, dy: 5), cornerWidth: 10, cornerHeight: 10, transform: nil)
        maskLayer.shadowOpacity = 1
        maskLayer.shadowOffset = CGSize.zero
        maskLayer.shadowColor = UIColor.white.cgColor
        cell.layer.mask = maskLayer
        
        
        let url = URL(string: arr[indexPath.item])
        //let placeHolderImage = UIImage(named: "placeholder.png")
        //let image = images[indexPath.item]
        
        var pop = Image(id: "image-\(indexPath.item)", description: "image-\(indexPath.item)")
        
        cell.popImage = pop
        DispatchQueue.main.async {
            cell.imageView.af_setImage(withURL: url!)
            self.imageIDs.append(cell.imageView.image!)
        }
        stopIndicator()
        self.LoadingStackView.isHidden = true
 
        return cell
    }
}
