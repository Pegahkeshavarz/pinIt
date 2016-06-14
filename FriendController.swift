//
//  FriendsController.swift
//  facebooknewsfeed
//

import UIKit

private let reuseIdentifier = "Cell"

class FriendController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var backBtn: UIBarButtonItem!

    var friends: [Friend]?
    
    let showFriendsButton: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show Friends", forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.tintColor = UIColor.blueColor()
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        self.view.addSubview(navBar);
        let navItem = UINavigationItem(title: "SomeTitle");
        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: nil, action: "selector");
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        
        
        // Register cell classes
        self.collectionView!.registerClass(FriendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
        override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends != nil ? friends!.count : 0
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let friendCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! FriendCell
        
        if let friend = friends?[indexPath.item], name = friend.name, picture = friend.picture {
            friendCell.nameLabel.text = name
            
            friendCell.userImageView.image = nil
            
            if let url = NSURL(string: picture) {
                if let image = FriendController.imageCache.objectForKey(url) as? UIImage {
                    friendCell.userImageView.image = image
                    //                    print("cache hit for \(name)")
                } else {
                    NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        FriendController.imageCache.setObject(image!, forKey: url)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            friendCell.userImageView.image = image
                        })
                        
                    }).resume()
                }
                
            }
        }
        return friendCell
    }
    
    static let imageCache = NSCache()
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.width, 50)
    }
}

class FriendCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFontOfSize(14)
        return label
    }()
    
    
    let FriendsButton: UIButton = {
        let button = UIButton(type: .System)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(12)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.tag = 0
        return button
    }()

    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    func setupViews() {
        addSubview(userImageView)
        addSubview(nameLabel)
        
        FriendsButton.addTarget(self, action: "showFakeInfo", forControlEvents: .TouchUpInside)
        
        if FriendsButton.tag == 0 {
        addSubview(FriendsButton)
        }
        
        
        

        
        addConstraintsWithFormat("H:|-310-[v0(48)]-0-|", views: FriendsButton)
        addConstraintsWithFormat("V:|-1-[v0(48)]-1-|", views: FriendsButton)
        
        addConstraintsWithFormat("H:|-8-[v0(48)]-8-[v1]|", views: userImageView, nameLabel, FriendsButton)
        
        addConstraintsWithFormat("V:|[v0]|", views: nameLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(48)]", views: userImageView)
    }
    
    func showFakeInfo(){
//        let fakeLabel: UITextField = {
//            let label = UITextField()
//            label.font = UIFont.boldSystemFontOfSize(15)
//            label.text = "shared"
//            label.backgroundColor = UIColor.whiteColor()
//            label.tintColor = UIColor.blackColor()
//            return label
//        }()
//        addSubview(fakeLabel)
//        addConstraintsWithFormat("H:|-150-[v0(48)]-50-|", views: fakeLabel)
//        addConstraintsWithFormat("V:|-250-[v0(48)]-40-|", views: fakeLabel)
        FriendsButton.tag = 1
        
        if(FriendsButton.tag == 1){
        FriendsButton.hidden = true
        FriendsButton.tag = 0
        }
      
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}