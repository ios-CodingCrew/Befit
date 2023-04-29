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

class CheckinViewController: UIViewController {
    var delegate: ViewControllerBDelegate?
    
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
    

    @IBAction func onDoneTapped(_ sender: Any) {
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
