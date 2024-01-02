//
//  ViewController.swift
//  FetchDataFromApiAssignment3TableView
//
//  Created by Mac on 20/12/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    var post : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        initializeTableView()
        registerXIBWithtableView()
    }
    func fetchData()
    {
            let postUrl = URL(string: "https://jsonplaceholder.typicode.com/todos")
        
            var postUrlRequest = URLRequest(url: postUrl!)
            postUrlRequest.httpMethod = "Get"
            
        let postUrlSession = URLSession(configuration: .default)
        let postDataTask = postUrlSession.dataTask(with: postUrlRequest) { postData, postResponse, postError in
            print(postData)
            print(postResponse)
            print(postError)
            let postUrlResonse = try! JSONSerialization.jsonObject(with: postData!) as! [[String : Any]]
            
            for eachPostResponse in postUrlResonse{
                let postDictionary = eachPostResponse as! [String : Any]
                let postUserId = postDictionary["userId"] as! Int
                let postId = postDictionary["id"] as! Int
                let postTitle = postDictionary["title"] as! String
                let postCompleted = postDictionary["completed"] as! Bool

                let postObject = Post(userId: postUserId, id: postId, title: postTitle, completed: postCompleted)

                self.post.append(postObject)

            }
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        postDataTask.resume()

    }
    func initializeTableView()
    {
        postTableView.dataSource = self
        postTableView.delegate = self
    }
    func registerXIBWithtableView()
    {
        let uinib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(uinib, forCellReuseIdentifier: "PostTableViewCell")
        
    }
}
extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let postTableViewCell = self.postTableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        postTableViewCell.userIdLabel.text = String(post[indexPath.row].userId)
        postTableViewCell.idLabel.text = String(post[indexPath.row].id)
        postTableViewCell.titleLabel.text = post[indexPath.row].title
        postTableViewCell.completedLabel.text = String(post[indexPath.row].completed)
        
        return postTableViewCell
        
    }
    
    
}
extension ViewController : UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170.5
    }
}
