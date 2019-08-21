//
//  CollectionViewFullDemo.swift
//  SSPlaceHolderTableView
//
//  Created by Vishal Patel on 11/01/19.
//  Copyright © 2019 Vishal Patel. All rights reserved.
//

import UIKit

class CollectionViewFullDemo: UIViewController {

    @IBOutlet weak var collectionView: CollectionView!
    var reachability: Reachability!
    var isForNoData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.onNoDataButtonTouch = {
            // put your network Call here.
            self.callAPI(isForNoData: self.isForNoData)
        }
    }
    
    @IBAction func btnActionNoDataAPi(_ sender: Any) {
        isForNoData = true
        callAPI(isForNoData: isForNoData)
    }
    
    @IBAction func btnActionDataApi(_ sender: Any) {
        isForNoData = false
        callAPI(isForNoData: isForNoData)
    }
    
}
extension CollectionViewFullDemo {
    func callAPI(isForNoData: Bool) {
        reachability = Reachability()!
        if reachability.connection != .none {
            self.collectionView.setState(.loading(loadingImg: nil, loadingLabelTitle: nil))
            let urlString : String = "https://jsonplaceholder.typicode.com/comments?postId=\(isForNoData ? 0 : 1)"
            let url = URL(string: urlString)
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
                do {
                    let arrJson = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
                    print(arrJson)
                    DispatchQueue.main.async {
                        if arrJson.count > 0 {
                            self.collectionView.setState(.dataAvailable(viewController: self))
                        } else {
                            self.collectionView.setState(.noDataAvailable(noDataImg: nil, noDataLabelTitle: NSAttributedString(string: "No Data Found. Oh. O!!!"), noDataLabelDescription: NSAttributedString(string: "Oh. O!!! its seems that no data availiable to show")))
                        }
                    }
                } catch {
                    print("error")
                }
            })
            task.resume()
        } else {
            self.collectionView.setState(.noDataAvailableWithButton(noDataImg: nil, noDataLabelTitle: NSAttributedString(string: "No Internet"), noDataLabelDescription: NSAttributedString(string: "Oops!!! its seems that you are not connected to internet.")))
        }
        
    }
    
    
    
}
extension CollectionViewFullDemo : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
        return cell
    }
}
