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

class MoviesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var alphabeticalButton: UIButton!
    @IBOutlet weak var releaseDateButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var movies: [NSDictionary]?
    var filteredData: [NSDictionary]?
    let refreshControl = UIRefreshControl()
    var endPoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView.delegate = self
        //tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        // Font attributes for navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 22), NSForegroundColorAttributeName: UIColor(red: 235/255, green: 220/255, blue: 178/255, alpha: 1)]
        
        // Custom views for the loading state
        EZLoadingActivity.Settings.BackgroundColor = UIColor.black
        EZLoadingActivity.Settings.TextColor = UIColor.white
        EZLoadingActivity.Settings.ActivityColor = UIColor.white
        
        // Resfresh-to-control functionality
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction), for: UIControlEvents.valueChanged)
        //tableView.insertSubview(refreshControl, at: 0)
        collectionView.insertSubview(refreshControl, at: 0)
        
        sortView.layer.cornerRadius = 5.0
        alphabeticalButton.layer.cornerRadius = 5.0
        releaseDateButton.layer.cornerRadius = 5.0
        sortButton.layer.cornerRadius = 5.0
        
        makeApiCall()
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
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData?.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewCell
        let movie = filteredData![indexPath.row]
        //let baseUrl = "https://image.tmdb.org/t/p/w342"
        let smallBaseUrl = "https://image.tmdb.org/t/p/w45"
        let largeBaseUrl = "https://image.tmdb.org/t/p/original"
        
        if let posterUrl = movie["poster_path"] as? String {
            
            //let imageUrl = NSURL(string: baseUrl + posterUrl)
            let smallImageUrl = NSURL(string: smallBaseUrl + posterUrl)
            let largeImageUrl = NSURL(string: largeBaseUrl + posterUrl)
            
            //let imageRequest = NSURLRequest(url: imageUrl as! URL)
            let smallImageRequest = NSURLRequest(url: smallImageUrl as! URL)
            let largeImageRequest = NSURLRequest(url: largeImageUrl as! URL)
            
            // Load low resolution poster image, followed by the high resolution version
            cell.posterImageView.setImageWith(smallImageRequest as URLRequest, placeholderImage: nil, success: { (smallImageRequest, smallImageResponse, smallImage) in
                if smallImageResponse != nil {
                    
                    // Fade the images as they load
                    cell.posterImageView.alpha = 0
                    cell.posterImageView.image = smallImage
                    UIView.animate(withDuration: 0.5, animations: {
                        cell.posterImageView.alpha = 1
                        
                    }, completion: { (success) -> Void in
                        // Load high resolution after low resolution images are completed
                        cell.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: nil, success: { (largeImageRequest, slargeImageResponse, largeImage) in
                            cell.posterImageView.image = largeImage
                            
                        }, failure: {(imageRequest, imageResponse, error) -> Void in
                            
                        })
                    })
                } else {
                    //cell.posterImageView.image = smallImage
                    // If images are cached, load the large resolution image
                    cell.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: nil, success: { (largeImageRequest, slargeImageResponse, largeImage) in
                        cell.posterImageView.image = largeImage
                    }, failure: {(imageRequest, imageResponse, error) -> Void in
                        
                    })
                }
            }, failure: {(imageRequest, imageResponse, error) -> Void in
                
            })
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.cellBackgroundView.alpha = 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell =  collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        cell.cellBackgroundView.alpha = 0.5
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? movies : movies?.filter {
            ($0["title"] as! String).range(of: searchText, options: .caseInsensitive) != nil
        }
        
        //tableView.reloadData()
        collectionView.reloadData()
    }
    
    // Call this function when pulled-to-refresh
    func refreshControlAction() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                EZLoadingActivity.hide(true, animated: true)
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = dataDictionary["results"] as? [NSDictionary]
                    //self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } else {
                EZLoadingActivity.hide(false, animated: true)
                self.networkView.isHidden = false
            }
            //self.tableView.reloadData()
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
        task.resume()
    }
    
    // Make call due to network failure
    func makeApiCall() {
        EZLoadingActivity.show("Loading...", disableUI: true)
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endPoint!)?api_key=\(apiKey)&region=US")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                self.networkView.isHidden = true
                EZLoadingActivity.hide(true, animated: true) // Hide the loading state after data is loaded
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.filteredData = dataDictionary["results"] as? [NSDictionary]
                    //self.tableView.reloadData()
                    self.collectionView.reloadData()
                }
            } else {
                EZLoadingActivity.hide(false, animated: true)
                self.networkView.isHidden = false
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! CollectionViewCell
        let indexPath = collectionView.indexPath(for: cell)
        
        let movie = movies![(indexPath!.row)]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
    }
    
    // Make API call after network error pops up
    @IBAction func buttonPressed(_ sender: Any) {
        makeApiCall()
    }
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        sortView.isHidden = false
        collectionView.isUserInteractionEnabled = false
        collectionView.alpha = 0.2
    }
    
    @IBAction func alphabeticalButtonPressed(_ sender: Any) {
        sortView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        collectionView.alpha = 1
    }
    
    @IBAction func releaseDateButtonPressed(_ sender: Any) {
        sortView.isHidden = true
        collectionView.isUserInteractionEnabled = true
        collectionView.alpha = 1
    }
}
