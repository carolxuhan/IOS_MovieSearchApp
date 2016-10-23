//
//  FavoriteTableViewController.swift
//  MovieSearchApp
//
//  Created by Carol Han on 10/16/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import UIKit
import CoreData

class FavoriteTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate {
    
    var movies = [FavoriteMovie]()
    var imageCache = [String:UIImage]()
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        movies = FavoriteMovie.all()
        myTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        myTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        myTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        switch type {
        case .Insert:
            if let _newIndexPath = newIndexPath {
                myTableView.insertRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Delete:
            if let _newIndexPath = newIndexPath {
                myTableView.deleteRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        case .Update:
            if let _newIndexPath = newIndexPath {
                myTableView.reloadRowsAtIndexPaths([_newIndexPath], withRowAnimation: .Fade)
            }
        default:
            myTableView.reloadData()
        }
        movies = controller.fetchedObjects as! [FavoriteMovie]
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return movies.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Movie Cell", forIndexPath: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        cell.imageView?.image = UIImage(data: movie.poster)!
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let thismovie = Movie.convertToMoive(movies[myTableView.indexPathForSelectedRow!.row])
            thismovie.added = true
            print("Give ou ture")
            let Dest:DetailViewController = segue.destinationViewController as! DetailViewController
            Dest.movie = thismovie
        }
        
    }
  
}
