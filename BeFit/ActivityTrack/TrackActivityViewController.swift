//
//  TrackActivityViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit

class TrackActivityViewController: UIViewController{
    
//    let options = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5", "Option 6"]
//    let pickerView = UIPickerView()
//    var pickerViewVisible = false

    
    @IBOutlet weak var popupButton: UIButton!
    
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

    
    
    @IBAction func dropdownButtonTapped(_ sender: Any) {
//        pickerView.isHidden = false
//
//        UIView.animate(withDuration: 0.3) {
//              let constant: CGFloat = self.pickerView.isHidden ? 200 : 0
//              self.pickerView.bottomAnchor.constraint(equalTo: self.dropdownButton.bottomAnchor, constant: constant).isActive = true
//              self.view.layoutIfNeeded()
//          }

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
        //TODO: save info to database
        
        //TODO: exit to main page
        performSegue(withIdentifier: "backToPlaygroundVC", sender: self)
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
