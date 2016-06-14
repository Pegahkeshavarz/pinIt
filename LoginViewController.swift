//


import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate  {
    
    //addu User Defaults
    let defaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var bgImage: UIImageView!
    //var friends = [Friend]()
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
       
        button.readPermissions = ["email","user_friends","public_profile"]
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationController?.navigationBar.translucent = false
        //loginButton.hi
        
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.title = "Facebook Login"
        view.addSubview(loginButton)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-60-[v0]-60-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": loginButton]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-400-[v0]-200-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": loginButton]))
        let verticalSpace = NSLayoutConstraint(item:self.view , attribute: .Bottom, relatedBy: .Equal, toItem:loginButton , attribute: .Bottom, multiplier: 1, constant: 220)
        
        NSLayoutConstraint.activateConstraints([verticalSpace])
        
        loginButton.delegate = self
       
        
        
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        if(FBSDKAccessToken.currentAccessToken() != nil){
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            loginButton.hidden = true
            dispatch_async(dispatch_get_main_queue(), {
                self.presentViewController(next, animated: true, completion: nil)
            })
            print("go to next page")
        }
    }
    
    
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if(error != nil){
            print(error.localizedDescription)
            return
        }
        
        if let userToken = result.token{
        
        
        //get user access token
        let token: FBSDKAccessToken = result.token
            print("Token = \(FBSDKAccessToken.currentAccessToken().tokenString)")
            print("user ID = \(FBSDKAccessToken.currentAccessToken().userID)")
            
            
            let next = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            self.presentViewController(next, animated: true, completion: nil)
            
            loginButton.hidden = true

            fetchProfile()
        }
    }
    
    
    
    func fetchProfile() {
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            print("i am fetching")
            if requestError != nil {
                print(requestError)
                return
            }
            
            let UserId = FBSDKAccessToken.currentAccessToken().userID
            self.defaults.setObject(UserId, forKey: "UserId")
            
            let email = user["email"] as? String
            self.defaults.setObject(email, forKey: "userEmail")
            
            let firstName = user["first_name"] as? String
            self.defaults.setObject(firstName, forKey: "firstName")
            
            let lastName = user["last_name"] as? String
            self.defaults.setObject(lastName, forKey: "lastName")
            
            let userName = "\(firstName!) \(lastName!)"
            
            self.defaults.setObject(userName, forKey: "userName")
            
            //self.nameLabel.text = "\(firstName!) \(lastName!)"
            
            var pictureUrl = ""
            
            
            if let picture = user["picture"] as? NSDictionary, data = picture["data"] as? NSDictionary, url = data["url"] as? String {
                pictureUrl = url
                
                self.defaults.setObject(pictureUrl, forKey: "imageUrl")

            }
            

        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}


struct Friend {
    var name, picture: String?
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerate() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
