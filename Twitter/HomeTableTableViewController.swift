//
//  HomeTableTableViewController.swift
//  Twitter
//
//  Created by Sebastian Ruiz on 10/1/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableTableViewController: UITableViewController {

    var tweetArr = [NSDictionary]()
    var numOfTweets:Int!
    
    let myRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        self.tableView.rowHeight = UITableView.automaticDimension
      self.tableView.estimatedRowHeight = 175
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadTweets()
    }
    
    @objc func loadTweets(){
        numOfTweets = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArr.removeAll()
            for tweet in tweets {
                self.tweetArr.append(tweet)
            }
            
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets! Oh no!!")
    })
        
    }
    
    func loadMoreTweets(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        
        numOfTweets = numOfTweets + 20
        
        let myParams = ["count": numOfTweets]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams as [String : Any], success: { (tweets: [NSDictionary]) in
                   
                   self.tweetArr.removeAll()
                   for tweet in tweets {
                       self.tweetArr.append(tweet)
                   }
                   
                   self.tableView.reloadData()

                   
               }, failure: { (Error) in
                   print("Could not retrieve tweets! Oh no!!")
        
    })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArr.count {
            loadMoreTweets()
        }
    }
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        let user = tweetArr[indexPath.row]["user"] as! NSDictionary
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text =  tweetArr[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: ((user["profile_image_url_https"] as? String)!))
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImgView.image =  UIImage(data: imageData)
        }
        
        cell.setFavorite(tweetArr[indexPath.row]["favorited"] as! Bool)
        
        cell.setRetweeted(tweetArr[indexPath.row]["retweeted"] as! Bool)
        
        cell.tweetid = tweetArr[indexPath.row]["id"] as! Int
        
        return cell
    }
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArr.count
    }


}
