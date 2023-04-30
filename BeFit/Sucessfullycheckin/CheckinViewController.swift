//
//  CheckinViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit


protocol ViewControllerBDelegate {
    func viewControllerBDidDismiss()
}

protocol CheckinViewControllerDelegate: AnyObject {
    func checkinViewControllerDidSaveCheckin()
}


class CheckinViewController: UIViewController {
    var delegate: ViewControllerBDelegate?
    weak var dbdelegate: CheckinViewControllerDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    @IBOutlet weak var bgImage: UIImageView!
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let startColor = UIColor(red: 204/255, green: 223/255, blue: 221/255, alpha: 1.0)
        let endColor = UIColor(red: 215/255, green: 235/255, blue: 232/255, alpha: 1.0)
        addGradientToImageView(imageView: bgImage, startColor: startColor, endColor: endColor)
        
        bgImage.layer.cornerRadius = bgImage.frame.size.width / 2
        bgImage.clipsToBounds = true
    
       
    }
    

    func addGradientToImageView(imageView: UIImageView, startColor: UIColor, endColor: UIColor) {
        let gradientLayer = CAGradientLayer()
           gradientLayer.frame = imageView.bounds
           gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
           gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
           gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
           imageView.layer.addSublayer(gradientLayer)
    }
    
    func saveWorkoutCount(workout: WorkoutCount) {
        workout.save { result in
            switch result {
            case .success(let savedWorkout):
                print("Successfully saved workout: \(savedWorkout)")
                self.dbdelegate?.checkinViewControllerDidSaveCheckin()
            case .failure(let error):
                print("Error saving workout: \(error)")
            }
        }
    }


    @IBAction func onDoneTapped(_ sender: Any) {
        let checkinDate = Calendar.current.startOfDay(for: Date())
        let workout = WorkoutCount(userid: User.current?.userid, workout_date: checkinDate, checkin_count: 1)
        saveWorkoutCount(workout: workout)

        
        performSegue(withIdentifier: "unwindToPlaygroundVC", sender: self)
    }
    
    /*
    // MARK: - Navigatio
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
