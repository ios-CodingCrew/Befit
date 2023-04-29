//
//  PlayGroundViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit
import QuartzCore
import ParseSwift

class PlayGroundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBOutlet weak var firstImageview: UIImageView!
    @IBOutlet weak var secImageview: UIImageView!
    @IBOutlet weak var thirdImageview: UIImageView!
    
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    
    //private let containerView = RoundedCornerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set background color
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
//            UIColor(red: 217/255, green: 164/255, blue: 159/255, alpha: 1).cgColor,
//            UIColor(red: 70/255, green: 196/255, blue: 187/255, alpha: 1).cgColor
            UIColor(red: 89/255, green: 182/255, blue: 192/255, alpha: 1).cgColor,
            UIColor(red: 224/255, green: 232/255, blue: 233/255, alpha: 1).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        view.layer.insertSublayer(gradientLayer, at: 0)

        
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        
        firstImageview.layer.cornerRadius = 10
        secImageview.layer.cornerRadius = 10
        thirdImageview.layer.cornerRadius = 10
        
        //set up navigation bar: add text
        let labelText = "Welcome Back!"
        let label = UILabel()
        label.text = labelText
        label.font = UIFont(name: "Avenir Next-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textColor = .white // Adjust the text color as needed
        
        let leftBarItem = UIBarButtonItem(customView: label)
        navigationItem.leftBarButtonItem = leftBarItem
        
        //set up 'log out' button


        //set up segmented control
        let font = UIFont(name: "Verdana", size: 16) ?? UIFont.systemFont(ofSize: 16) // Use Impact font or fall back to system font if not available
           let textColor: UIColor = .white // Choose your desired text color
           let normalAttributes: [NSAttributedString.Key: Any] = [
               .font: font,
               .foregroundColor: textColor
           ]

           segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
        let font2 = UIFont(name: "Verdana-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
           // Optional: set font and color for the selected segment
           let selectedTextColor: UIColor = .white// Choose your desired selected text color
           let selectedAttributes: [NSAttributedString.Key: Any] = [
               .font: font2,
               .foregroundColor: selectedTextColor
           ]

           segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        
        setCellsView()
        setMonthView()
    }
    
    func setCellsView(){
        print("frames' w: \(collectionView.frame.size.width) and h: \(collectionView.frame.size.height)")
        let width = (collectionView.frame.size.width-50)/7
        //let height = (collectionView.frame.size.height-50)/7
        let height = width
        print("w: \(width) h: + \(height)")
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.sectionInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        flowLayout.itemSize = CGSize(width: width, height: height)
        //flowLayout.invalidateLayout()
    }
    
    func setMonthView(){
        totalSquares.removeAll()
        
        let daysInMonth = CalendarHelper().daysInMonth(date: selectedDate)
        let firstDayOfMonth = CalendarHelper().firstOfMonth(date: selectedDate)
        let startingSpaces = CalendarHelper().weekDay(date: firstDayOfMonth)
        
        var count: Int = 1
        
        while(count<=42){
            if( count <= startingSpaces || count - startingSpaces > daysInMonth){
                totalSquares.append("")
            }else{
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        monthLabel.text =  CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        
        //TODO: set backgound color corresonding to workout time
        if(totalSquares[indexPath.item] == ""){
            cell.backgroundColor =  UIColor(red: 235.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 0.0)
        }else{
            //TODO: decide color here
            cell.backgroundColor = UIColor.systemMint
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width-50)/7
        let height = width
        //let height = (collectionView.frame.size.height-50)/7
        return CGSize(width: width, height: height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }


    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = (collectionView.frame.size.width-2)/8
//        let height = (collectionView.frame.size.height-2)/8
//        return CGSize(width: width-4, height: height-4)
//    }

    
    @IBAction func toCheckin(_ sender: Any) {
        performSegue(withIdentifier: "toCheckin", sender: nil)
    }
    
    @IBAction func toTrack(_ sender: Any) {
        performSegue(withIdentifier: "toTrack", sender: nil)
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
    }
    
    override open var shouldAutorotate: Bool{
        return false
    }
    
    
    @IBAction func onLogOutTapped(_ sender: Any) {
        showConfirmLogoutAlert()
    }
    
    
    private func showConfirmLogoutAlert() {
        let alertController = UIAlertController(title: "Log out of \(User.current?.username ?? "current account")?", message: nil, preferredStyle: .alert)
        let logOutAction = UIAlertAction(title: "Log out", style: .destructive) { _ in
            NotificationCenter.default.post(name: Notification.Name("logout"), object: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(logOutAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    
    @IBAction func unwindToPlaygroundVC(segue: UIStoryboardSegue) {
        
    }

    @IBAction func backToPlaygroundVC(segue: UIStoryboardSegue) {
        
    }


}
