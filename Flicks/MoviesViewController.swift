//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Sang Saephan on 1/12/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit
import AFNetworking
import EZLoadingActivity

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Custom views for the loading state
        EZLoadingActivity.Settings.BackgroundColor = UIColor.black
        EZLoadingActivity.Settings.TextColor = UIColor.white
        EZLoadingActivity.Settings.ActivityColor = UIColor.white
        
        // Resfresh-to-control functionality
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                EZLoadingActivity.hide(true, animated: true) // Hide the loading state after data is loaded
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
            } else {
                EZLoadingActivity.hide(false, animated: true)
            }
        }
        task.resume()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        EZLoadingActivity.show("Loading...", disableUI: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterUrl = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        let imageUrl = NSURL(string: baseUrl + posterUrl)
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.posterImageView.setImageWith(imageUrl as! URL)
        
        return cell
    }
    
    // Call this function when pulled-to-refresh
    func refreshControlAction() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                EZLoadingActivity.hide(true, animated: true)
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        task.resume()
    }

}
