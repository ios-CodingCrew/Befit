//
//  TrackActivityViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit

// Define the delegate protocol
protocol TrackActivityDelegate: AnyObject {
    func didSaveWorkoutData()
}


class TrackActivityViewController: UIViewController{
    
//    let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
//    let pickerView = UIPickerView()
//    var pickerViewVisible = false
    weak var delegate: TrackActivityDelegate?
    
    @IBOutlet weak var popupButton: UIButton!
    @IBOutlet weak var timeInput: UITextField!
    @IBOutlet weak var calInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setPopupButton()
//        pickerView.delegate = self
//        pickerView.dataSource = self
////        dropdownButton.setTitle(options[0], for: .normal)
////        dropdownButton.addTarget(self, action: #selector(dropdownButtonTapped), for: .touchUpInside)
//        pickerView.translatesAutoresizingMaskIntoConstraints = false
//        pickerView.isHidden = true
//        view.addSubview(pickerView)
//
    
    }

    
    
    func setPopupButton(){
        let optionClosure = {(action: UIAction) in
            print(action.title )
        }
        
        popupButton.menu = UIMenu(children: [
            UIAction(title: "StairsStepper", state: .on, handler: optionClosure),
            UIAction(title: "TreadMill", handler: optionClosure),
            UIAction(title: "WeightLifting", handler: optionClosure),
            UIAction(title: "Rowing", handler: optionClosure),
            UIAction(title: "Yoga", handler: optionClosure),
            UIAction(title: "Indoor cycling", handler: optionClosure)])
        
        popupButton.showsMenuAsPrimaryAction =  true
        popupButton.changesSelectionAsPrimaryAction = true
    }
    
    
    
    @IBAction func onSaveTapped(_ sender: Any) {
        
        guard let d = timeInput.text,
              let c = calInput.text,
              !d.isEmpty,
              !c.isEmpty else {

            showMissingFieldsAlert()
            return
        }
        
        
        //TODO: save info to database
        if let currentUser = User.current {
            let  workoutType = popupButton.title(for: .normal) ?? ""// Replace with the actual workout type
            
            let duration = Int(d) ?? 0
            let caloriesBurnt = Int(c) ?? 0
            
            saveWorkoutData(user: currentUser, workoutType: workoutType, duration: duration, caloriesBurnt: caloriesBurnt) { success, error in
                if success {
                    print("Workout data saved successfully. Type: \(workoutType) Time: \(duration) cal:\(caloriesBurnt)")
                } else {
                    print("Error saving workout data: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        } else {
            print("No current user is logged in")
        }

        
        //TODO: exit to main page
        performSegue(withIdentifier: "backToPlaygroundVC", sender: self)
    }
    
    
    func saveWorkoutData(user: User, workoutType: String, duration: Int, caloriesBurnt: Int, completion: @escaping (Bool, Error?) -> Void) {
        let user = User.current
        let workoutData = WorkoutData(userid: user?.userid, workout_id: nil, workout_date: Date(), workout_type: workoutType, duration: duration, calories_burnt: caloriesBurnt)

        workoutData.save { result in
            switch result {
            case .success(let savedWorkoutData):
                print("Workout data saved successfully: \(savedWorkoutData)")
                self.delegate?.didSaveWorkoutData()
                completion(true, nil)

            case .failure(let error):
                print("Error saving workout data: \(error.localizedDescription)")
                completion(false, error)
            }
        }
        
        self.delegate?.didSaveWorkoutData()
    }
    
    
    private func showMissingFieldsAlert() {
        let alertController = UIAlertController(title: "Opps...", message: "We need all fields filled out.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true)
    }

    
    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return options.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return options[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        dropdownButton.setTitle(options[row], for: .normal)
//        //pickerView.isHidden = true
//
//    }
//


}
