//
//  DetailViewController.swift
//  MovieSearchApp
//
//  Created by Carol Han on 10/16/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import UIKit
import Social
import CoreData


class DetailViewController: UIViewController{
    
    var movie = Movie()
    
    @IBOutlet weak var titleText: UINavigationItem!
    @IBOutlet var releaseedLabel : UILabel!
    @IBOutlet var ratingLabel : UILabel!
    @IBOutlet var directorLabel : UILabel!
    @IBOutlet var plotLabel : UILabel!
    @IBOutlet var posterImageView : UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        
        titleText.title = movie.title
        posterImageView.image = movie.poster
        favoriteButton.setTitle("Add To Favorite", forState: UIControlState.Normal)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        NSOperationQueue.mainQueue().addOperationWithBlock({
            if ((self.navigationController?.viewControllers[0] is SearchTableViewController)||(self.navigationController?.viewControllers[0] is  FavoriteTableViewController)) {
                for savedMovie in FavoriteMovie.all() {
                    if self.movie.imdbId == savedMovie.imdbId {
                        self.movie.added = true
                        self.favoriteButton.setTitle("Delete From Favorite", forState: UIControlState.Normal)
                    }
                }
            }
        })
        
        
        let searchContent =  "https://www.omdbapi.com/?i="+movie.imdbId
        let urlPath = NSURL(string: searchContent)!
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(urlPath,completionHandler:{
            (data, response, error) -> Void in
            if((error) != nil){
                print(error?.localizedDescription)
            }
            let result:Dictionary<String,String>
            do{
                result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! Dictionary<String,String>
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.releaseedLabel.text = "Released: "+result["Released"]!
                    self.ratingLabel.text = "Rated: "+result["Rated"]!
                    self.directorLabel.text = "Director: "+result["Director"]!
                    self.plotLabel.text = result["Plot"]!+"\n \n \n"
                    self.indicator.stopAnimating()
                })
                
                
            }catch{
                //self.delegate!.setActivityIndicatorVisibility(false)
                print("Fetch failed:\((error as NSError).localizedDescription)")
            }
        })
        task.resume()
    }
    
    @IBAction func actionButton(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Share via Twitter", style: .Default, handler: {(action)-> Void in
            
            let twitterShare = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            if self.movie.poster != UIImage(named: "noPoster") {
                twitterShare.addImage(self.movie.poster)
            }
            twitterShare.addURL(NSURL(string: "http://www.imdb.com/title/\(self.movie.imdbId)/"))
            if self.movie.title != "N/A" {
                twitterShare.setInitialText("\(self.movie.title) is a great movie!")
            }
            self.presentViewController(twitterShare, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Share via Facebook", style: .Default, handler: {(action)-> Void in
            
            let facebookShare = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if self.movie.poster != UIImage(named: "noPoster") {
                facebookShare.addImage(self.movie.poster)
            }
            facebookShare.addURL(NSURL(string: "http://www.imdb.com/title/\(self.movie.imdbId)/"))
            if self.movie.title != "N/A" {
                facebookShare.setInitialText("This \(self.movie.title) is a great movie!")
            }
            self.presentViewController(facebookShare, animated: true, completion: nil)
        }))
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonPressed(sender:UIButton){
        if !movie.added {
            FavoriteMovie.addMovie(self.movie)
            self.movie.added = true
            favoriteButton.setTitle("Delete From Favorite", forState: UIControlState.Normal)
        } else {
            self.movie.added = false
            FavoriteMovie.deleteMovie(self.movie)
            favoriteButton.setTitle("Add To Favorite", forState: UIControlState.Normal)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
}