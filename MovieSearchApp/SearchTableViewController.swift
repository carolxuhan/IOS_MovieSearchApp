//
//  SearchTableViewController.swift
//  MovieSearchApp
//
//  Created by Carol Han on 10/16/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import UIKit

class SearchTableViewController: UIViewController,UISearchBarDelegate,IMDBAPIControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var searchResults = [Movie]()
    var imageCache = [String:UIImage]()
    var newSearch = 0
    
    @IBOutlet weak var searchingIndicator: UIActivityIndicatorView!
    
    
    @IBOutlet var imdbSearchBar: UISearchBar!
    @IBOutlet weak var myTableView: UITableView!
    lazy var apiController : IMDBAPIController = IMDBAPIController(delegate:self)    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apiController.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SearchTableViewController.userTappedInView(_:)))
        //self.view.addGestureRecognizer(tapGesture)
        
        
        // Uncomment the following line to preserve selection between presentations
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishIMDBSearch(results: [AnyObject]) {
        
        if (results.isEmpty == false) {
            for result in results{
                //self.posterImageView.image = nil
                let movie =  Movie()
                movie.title = (result["Title"] as? String)!
                movie.imdbId = (result["imdbID"] as? String)!
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if let foundPosterUrl = result["Poster"] as? String{
                        if let image = self.imageCache[foundPosterUrl]{
                            movie.poster = image
                        }else{
                            let posterUrl = NSURL(string: foundPosterUrl)
                            if let posterImageData = NSData(contentsOfURL: posterUrl!){
                                movie.poster = UIImage(data: posterImageData)
                                self.imageCache[foundPosterUrl] = movie.poster
                            }else{
                                movie.poster = UIImage.init(named: "na.jpg")
                            }
                        }
                        
                    }
                })
                
                searchResults.append(movie)
            }
        }else{
            searchResults = []
        }
        newSearch = 1
        NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in self.myTableView.reloadData()})
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        newSearch = 0
        searchResults.removeAll()
        NSOperationQueue.mainQueue().addOperationWithBlock({()-> Void in self.myTableView.reloadData()})
        self.searchingIndicator.startAnimating()
        self.apiController.searchIMDB(searchBar.text!)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchResults.count==0&&newSearch==1 {
            return 1
        }else{
            return searchResults.count
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Movie Cell", forIndexPath: indexPath)
        if searchResults.count==0&&newSearch==1 {
            cell.textLabel?.text = "No qualified results"
        }else{
            let movie = searchResults[indexPath.row]
            cell.textLabel?.text = movie.title
            cell.imageView?.image = movie.poster
        }
        searchingIndicator.stopAnimating()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let Dest:DetailViewController = segue.destinationViewController as! DetailViewController
            Dest.movie = searchResults[myTableView.indexPathForSelectedRow!.row]
        }
        
    }
}

