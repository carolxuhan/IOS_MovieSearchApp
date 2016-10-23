//
//  FavoriteMovie.swift
//  MovieSearchApp
//
//  Created by Carol Han on 10/17/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import UIKit
import CoreData

class FavoriteMovie: NSManagedObject {
    
    @NSManaged var imdbId: String
    @NSManaged var poster: NSData
    @NSManaged var title: String
    
    
    
    static func addMovie(movie: Movie) {
        
        for savedMovie in FavoriteMovie.all() {
            if savedMovie.imdbId == movie.imdbId {
                return
            }
        }
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let savingMovie = NSEntityDescription.insertNewObjectForEntityForName("FavoriteMovie", inManagedObjectContext: context) as! FavoriteMovie
            savingMovie.title = movie.title
            savingMovie.imdbId = movie.imdbId
            savingMovie.poster = UIImagePNGRepresentation(movie.poster!)!
            do {
                try context.save()
            } catch {
                print("error while creating")
            }
        }
    }
    
    static func all()-> [FavoriteMovie] {
        
        var fetchedController : NSFetchedResultsController!
        if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
            let request = NSFetchRequest(entityName: "FavoriteMovie")
            request.sortDescriptors = [NSSortDescriptor(key: "imdbId", ascending: true)]
            fetchedController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedController.delegate = FavoriteTableViewController()
            do {
                try fetchedController.performFetch()
            } catch {
                print("unsucced fetching")
            }
            
        }
        return fetchedController.fetchedObjects as! [FavoriteMovie]
    }
    
    static func deleteMovie(movie: Movie) {
        
        for savedMovie in FavoriteMovie.all() {
            if savedMovie.imdbId == movie.imdbId {
                if let context = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext {
                    context.deleteObject(savedMovie)
                    do {
                        try context.save()
                    } catch {
                        print("error while deleting")
                    }
                }
            }
        }
        
    }
}
