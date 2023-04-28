//
//  SignupViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit

class SignupViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var ppasswordField: UITextField!
    
    
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var unlockLabel: UILabel!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var potentialLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupLabel.textColor = UIColor.white
        toLabel.textColor = UIColor.white
        unlockLabel.textColor = UIColor(red: 0.0/255.0, green: 223.0/255.0, blue: 213.0/255.0, alpha: 1.0)
        fullLabel.textColor = UIColor.white
        potentialLabel.textColor = UIColor.white
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUpTapped(_ sender: Any) {
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = ppasswordField.text,
              !username.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {

            showMissingFieldsAlert()
            return
        }

        // TODO: Pt 1 - Parse user sign up
        var newUser = User()
        newUser.username = username
        newUser.email = email
        newUser.password = password

        newUser.signup { [weak self] result in

            switch result {
            case .success(let user):

                print("✅ Successfully signed up user \(user)")

                // Post a notification that the user has successfully signed up.
                NotificationCenter.default.post(name: Notification.Name("login"), object: nil)

            case .failure(let error):
                // Failed sign up
                self?.showAlert(description: error.localizedDescription)
            }
        }
    }
    
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out in order to sign you up.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
