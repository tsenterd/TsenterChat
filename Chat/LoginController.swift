import UIKit
import Firebase
class LoginController: UIViewController,UITextFieldDelegate {
    
    var  messagesController: MessagesController?
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    
    let titleTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TsenterChat 1.0"
        textView.textAlignment = .Center
        textView.font = UIFont.boldSystemFontOfSize(24)
        textView.textColor = UIColor.whiteColor()
        textView.editable = false
        textView.backgroundColor = UIColor.clearColor()
        return textView
    }()
    let hintTextView:UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Tap the top image to change your profile picture when registering!"
        textView.textAlignment = .Center
        textView.font = UIFont.boldSystemFontOfSize(12)
        textView.textColor = UIColor.whiteColor()
        textView.editable = false
        textView.backgroundColor = UIColor.clearColor()
        return textView
    }()
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .System)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        button.addTarget(self, action: #selector(handleLoginRegister), forControlEvents: .TouchUpInside)
        return button
    }()
    

    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.secureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .ScaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage)))
        imageView.userInteractionEnabled = true
        return imageView
    }()
    

    
    lazy var loginRegisterSegControl:UISegmentedControl = {
        let sc = UISegmentedControl(items:["Login","Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.whiteColor()
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), forControlEvents: .ValueChanged)
        return sc
    }()
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegControl.titleForSegmentAtIndex(loginRegisterSegControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, forState: .Normal)
        
        //change height of input container view
        inputContainterViewHeightConstraint?.constant = loginRegisterSegControl.selectedSegmentIndex == 0 ? 100 : 150
        //change height of name text field
        nameTextFieldHeightAnchor?.active = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        nameTextFieldHeightAnchor?.active = true
        
        emailTextFieldHeightAnchor?.active = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        passwordTextFieldHeightAnchor?.active = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: loginRegisterSegControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        view.addSubview(titleTextView)
        view.addSubview(hintTextView)
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegControl)
        
        
        titleTextView.leftAnchor.constraintEqualToAnchor(view.leftAnchor, constant: 10).active = true
        titleTextView.topAnchor.constraintEqualToAnchor(view.topAnchor,constant: 20).active = true
        titleTextView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        titleTextView.heightAnchor.constraintEqualToConstant(50).active = true
        

        
        hintTextView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        hintTextView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        hintTextView.topAnchor.constraintEqualToAnchor(loginRegisterButton.bottomAnchor,constant: 12).active = true
        hintTextView.heightAnchor.constraintEqualToConstant(50).active = true
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegControl()
        setupKeyboardObservers()
         self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("DismissKeyboard")))
    }
    func DismissKeyboard(){
        view.endEditing(true)
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(150).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(150).active = true
        profileImageView.topAnchor.constraintEqualToAnchor(titleTextView.bottomAnchor).active = true

    }
    
    var inputContainterViewHeightConstraint: NSLayoutConstraint?
    var nameTextFieldHeightAnchor:NSLayoutConstraint?
    var emailTextFieldHeightAnchor:NSLayoutConstraint?
    var passwordTextFieldHeightAnchor:NSLayoutConstraint?
    func setupInputsContainerView() {
        
        
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
      
        inputsContainerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor, constant: -24).active = true
        inputContainterViewHeightConstraint = inputsContainerView.heightAnchor.constraintEqualToConstant(150)
        inputContainterViewHeightConstraint?.active = true
    
        inputsContainerView.topAnchor.constraintEqualToAnchor(loginRegisterSegControl.bottomAnchor,constant: 8).active = true
        
        
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        nameTextField.topAnchor.constraintEqualToAnchor(inputsContainerView.topAnchor).active = true
        nameTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.active = true
        nameTextField.delegate = self
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        nameSeparatorView.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        nameSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        nameSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        emailTextField.topAnchor.constraintEqualToAnchor(nameTextField.bottomAnchor).active = true
        emailTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailTextField.delegate = self
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.active = true
        
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor).active = true
        emailSeparatorView.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        emailSeparatorView.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        emailSeparatorView.heightAnchor.constraintEqualToConstant(1).active = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraintEqualToAnchor(inputsContainerView.leftAnchor, constant: 12).active = true
        passwordTextField.topAnchor.constraintEqualToAnchor(emailTextField.bottomAnchor).active = true
        passwordTextField.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        passwordTextField.delegate = self
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraintEqualToAnchor(inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.active = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterButton.topAnchor.constraintEqualToAnchor(inputsContainerView.bottomAnchor, constant: 12).active = true
        loginRegisterButton.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterButton.heightAnchor.constraintEqualToConstant(50).active = true
    }
    func setupLoginRegisterSegControl(){
        loginRegisterSegControl.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        loginRegisterSegControl.topAnchor.constraintEqualToAnchor(profileImageView.bottomAnchor, constant: 10).active = true
        loginRegisterSegControl.widthAnchor.constraintEqualToAnchor(inputsContainerView.widthAnchor).active = true
        loginRegisterSegControl.heightAnchor.constraintEqualToConstant(36).active = true
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    
    func setupKeyboardObservers(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow), name: UIKeyboardWillShowNotification, object: self.view.window)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide), name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= (keyboardSize.height-100)
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += (keyboardSize.height-100)
            }
            else {
                
            }
            if (view.frame.origin.y != 0){
                self.view.frame.origin.y = 0
            }
        }
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: self.view.window)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: self.view.window)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if (textField === nameTextField) {
            emailTextField.becomeFirstResponder()
        } else if (textField === emailTextField) {
            passwordTextField.becomeFirstResponder()
        } else {
           view.endEditing(true)
                

        }
        
        return true
    }
}


extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
