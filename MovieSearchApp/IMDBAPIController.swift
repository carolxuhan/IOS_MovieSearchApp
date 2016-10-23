//
//  IMDBAPIController.swift
//  Movie Search
//
//  Created by Carol Han on 10/15/16.
//  Copyright © 2016 Carol Han. All rights reserved.
//

import UIKit


protocol IMDBAPIControllerDelegate {
    
    func didFinishIMDBSearch(result:[AnyObject])
    
}


class IMDBAPIController{
    
    var totalResults:Int
    var currentPage:Int
    var totalMovies:[AnyObject]
    
    var delegate : IMDBAPIControllerDelegate?
    init(delegate: IMDBAPIControllerDelegate?){
        self.delegate = delegate
        //set results limitation = 50, can be modified
        self.totalResults = 50
        self.currentPage = 1
        self.totalMovies = []
    }

    func searchIMDB(forContent:String) {
        self.totalResults = 50
        self.currentPage = 1
        self.totalMovies = []
        if let apiDelegate = self.delegate{
            while (self.currentPage*10 <= self.totalResults) {

                let searchContent =  "\(forContent)&plot=short&r=json&page=\(currentPage)"
                let spaceless = "https://www.omdbapi.com/?s="+searchContent.stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
                let urlPath = NSURL(string: spaceless)!
                let task = NSURLSession.sharedSession().dataTaskWithURL(urlPath, completionHandler: {
                    (data, response, error) -> Void in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    if let data = data {
                        do {
                            let jsonToDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            let apiResponse = jsonToDictionary?["Response"] as! String
                            if apiResponse == "True" {
                                if let movies = jsonToDictionary?["Search"] as? [AnyObject] {
                                    
                                    let results = Int(jsonToDictionary!["totalResults"] as! String)!
                                    if(results<self.totalResults){
                                        self.totalResults = Int(jsonToDictionary!["totalResults"] as! String)!
                                    }
                                    self.totalMovies.appendContentsOf(movies)
                                    if(self.totalMovies.count>=self.totalResults){
                                        dispatch_async(dispatch_get_main_queue()){
                                            apiDelegate.didFinishIMDBSearch(self.totalMovies)
                                        }
                                    }
                                }
                            }else{
                                dispatch_async(dispatch_get_main_queue()){
                                    apiDelegate.didFinishIMDBSearch(self.totalMovies)
                                }
                            }
                            
                        } catch {
                            print(error)
                        }
                    }
                    
                })
                task.resume()
                self.currentPage += 1
            }

        }
    }
}
