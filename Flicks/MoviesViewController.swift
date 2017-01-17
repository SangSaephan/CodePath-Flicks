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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        // Custom views for the loading state
        EZLoadingActivity.Settings.BackgroundColor = UIColor.black
        EZLoadingActivity.Settings.TextColor = UIColor.white
        EZLoadingActivity.Settings.ActivityColor = UIColor.white
        
        // Resfresh-to-control functionality
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        makeApiCall()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        EZLoadingActivity.show("Loading...", disableUI: true)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = filteredData![indexPath.row]
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies?.filter {
            ($0["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }
        
        tableView.reloadData()
    }
    
    // Call this function when pulled-to-refresh
    func refreshControlAction() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                EZLoadingActivity.hide(true, animated: true)
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredData = dataDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
            } else {
                EZLoadingActivity.hide(false, animated: true)
                self.networkView.isHidden = false
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    // Make call due to network failure
    func makeApiCall() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                self.networkView.isHidden = true
                EZLoadingActivity.hide(true, animated: true) // Hide the loading state after data is loaded
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    self.filteredData = dataDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
            } else {
                EZLoadingActivity.hide(false, animated: true)
                self.networkView.isHidden = false
            }
        }
        task.resume()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        makeApiCall()
    }
}
