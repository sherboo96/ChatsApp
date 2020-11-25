//
//  ViewController.swift
//  ChatsApp
//
//  Created by Mahmoud Sherbeny on 11/1/20.
//

import UIKit
import ImagePicker
import Firebase
import ProgressHUD

class WelcomeVC: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameText: UITextField! {
        didSet {
            nameText.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var emailText: UITextField! {
        didSet {
            emailText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var passwordText: UITextField! {
        didSet {
            passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white.withAlphaComponent(0.5)])
        }
    }
    @IBOutlet weak var signupBtn: UIButton! {
        didSet {
            signupBtn.layer.cornerRadius = 10.0
        }
    }
    
    @IBOutlet weak var welcomeStatus: UILabel!
    
    //MARK: - Variable
    var leftSwip = UISwipeGestureRecognizer()
    var rightSwip = UISwipeGestureRecognizer()
    var imageSelected = UITapGestureRecognizer()
    var profileIMG: UIImage?
    
    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - IBAction
    @objc func swip() {
        if signupBtn.titleLabel?.text == "Sign Up" {
            signupBtn.setTitle("Sign In", for: .normal)
            welcomeStatus.text = "Swip to Sign Up"
            nameText.isHidden = true
            profileImage.isHidden = true
        } else {
            signupBtn.setTitle("Sign Up", for: .normal)
            welcomeStatus.text = "Swip to Sign In"
            nameText.isHidden = false
            profileImage.isHidden = false
        }
    }
    
    @objc func imageSelection() {
        let imageSelector = ImagePickerController()
        imageSelector.imageLimit = 1
        imageSelector.delegate = self
        present(imageSelector, animated: true, completion: nil)
    }
    
    @IBAction func signPressed(_ sender: UIButton) {
        if signupBtn.titleLabel?.text == "Sign Up" {
            signUpUser()
        } else {
            signInUser()
        }
    }
    
    //MARK: - Helper Function
    func setupUI() {
        
        self.profileImage.isUserInteractionEnabled = true
        
        leftSwip.direction = .left
        rightSwip.direction = .right
        
        self.view.addGestureRecognizer(leftSwip)
        self.view.addGestureRecognizer(rightSwip)
        self.profileImage.addGestureRecognizer(imageSelected)
        
        leftSwip.addTarget(self, action: #selector(self.swip))
        rightSwip.addTarget(self, action: #selector(self.swip))
        imageSelected.addTarget(self, action: #selector(self.imageSelection))
    }
    
    func signInUser() {
        guard !emailText.text!.isEmpty, !passwordText.text!.isEmpty else {
            ProgressHUD.showError("Fill All Property")
            return
        }
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            guard let authData = authData else {
                return
            }
            
            saveCurrentUserLocally(userId: authData.user.uid) { (success) in
                if success == true {
                    self.goToHome()
                } else {
                    ProgressHUD.showError("User not Save")
                }
            }
            
            
        }
    }
    
    func signUpUser() {
        guard !nameText.text!.isEmpty, !emailText.text!.isEmpty, !passwordText.text!.isEmpty, profileIMG != nil else {
            ProgressHUD.showError("Fill All Property")
            return
        }
        
        Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
                return
            }
            
            let stringImage = imageToString(image: self.profileIMG!)
            
            let userDic = FUser(objectId: Auth.auth().currentUser!.uid, username: self.nameText.text!, createdAt: Date(), updatedAt: Date(), email: self.emailText.text!, profileImage: stringImage)
            
            createNewUser(user: userDic)
            
            self.goToHome()
        }
    }
    
    func goToHome() {
        let VC = UIStoryboard.init(name: "Users", bundle: nil).instantiateViewController(identifier: "UserNav")
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .crossDissolve
        self.present(VC, animated: true, completion: nil)
    }
    
}

extension WelcomeVC: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        dismiss(animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        if images.count > 0 {
            self.profileIMG = images.first
            profileImage.image = profileIMG?.circleMasked
        }
        dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
