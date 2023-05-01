//
//  PlayGroundViewController.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import UIKit
import QuartzCore
import ParseSwift

class PlayGroundViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, TrackActivityDelegate, CheckinViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    @IBOutlet weak var firstImageview: UIImageView!
    @IBOutlet weak var secImageview: UIImageView!
    @IBOutlet weak var thirdImageview: UIImageView!
    
    @IBOutlet weak var bgView: UIImageView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var checkinTimes: UILabel!
    @IBOutlet weak var timeSpent: UILabel!
    @IBOutlet weak var calBurnt: UILabel!
    
    var selectedDate = Date()
    var totalSquares = [String]()
    var selectedSegmentIndex: Int = 0
    var selectedIndexPath: IndexPath?
    var currentYear: Int?
    var currentMonth: Int?


    
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
        
        //placeafter setting up the collectionView, or the totalSquares is empty
        //convert current date to indexPath
        selectedIndexPath = indexPathForCurrentDate()
        print("SI: \(String(describing: selectedIndexPath))")
        
        var name = ""
        
        updateWorkoutData()
        updateCheckinTimes()
        if let currentUser = User.current {
            name = currentUser.username ?? ""
        } else {
            print("No current user is logged in")
        }

        //set up navigation bar: add text
        var labelText = ""
        if(name == ""){
            labelText = "Welcome Back!"
        }else{
            labelText = name + ", Welcome Back!"
        }
        //let labelText = "Welcome Back!"
        let label = UILabel()
        label.text = labelText
        label.font = UIFont(name: "Avenir Next-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.textColor = .white // Adjust the text color as needed
        
        let leftBarItem = UIBarButtonItem(customView: label)
        navigationItem.leftBarButtonItem = leftBarItem

        
        
    }
    
    func indexPathForCurrentDate() -> IndexPath? {
        let currentDate = Date()
        let calendar = Calendar.current
        
        // Extract the day, month, and year components from the current date
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: currentDate)
        let currentDay = String(dateComponents.day!)
        print("currentDay: \(currentDay)")
        print("sq: \(totalSquares)")
        // Iterate through totalSquares and compare the day numbers
        for (index, element) in totalSquares.enumerated() {
            print("index: \(index), element: \(element)")
            if element == currentDay {
                return IndexPath(item: index, section: 0)
            }
        }
        
        return nil
    }

    
    //set up calendar view
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
        currentYear = CalendarHelper().yearInt(date: selectedDate)
        currentMonth = CalendarHelper().monthInt(date: selectedDate)
        monthLabel.text =  CalendarHelper().monthString(date: selectedDate) + " " + CalendarHelper().yearString(date: selectedDate)
        
        collectionView.reloadData()
    }
    
    //helper funtion for daily/monthly/yearly
    func formatDurationInHours(_ duration: Int) -> String {
        let hours = Double(duration) / 60.0
        return String(format: "%.1f hr", hours)
    }
 

    
    func getDailyWorkoutTime(for user: User, completion: @escaping (String?, Int?, Error?) -> Void) {
        print("in get daily workout")
        let now = selectedDate
        let calendar = Calendar.current
        
        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        let nowInUTC = dateFormatter.string(from: now)
        let nowUTC = dateFormatter.date(from: nowInUTC)

        let startOfDayUTC = calendar.startOfDay(for: nowUTC!)
        let endOfDayUTC = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDayUTC)
        
        print("Start of day: \(startOfDayUTC)")
        print("End of day: \(endOfDayUTC!)")
        print("Now: \(nowUTC!)")
        
        let query = WorkoutData.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfDayUTC)
            .where("workout_date" <= endOfDayUTC!)
        
        query.find { results in
            switch results {
            case .success(let workoutDataArray):
                let totalTime = workoutDataArray.compactMap { $0.duration }.reduce(0, +)
                let res = self.formatDurationInHours(totalTime)
                let totalCalories = workoutDataArray.compactMap { $0.calories_burnt }.reduce(0, +)
                completion(res, totalCalories, nil)
                print("daily time duration: \(totalTime), daily calories burnt: \(totalCalories)")
            case .failure(let error):
                completion(nil, nil, error)
            }
        }
    }

    func getMonthlyWorkoutTime(for user: User, completion: @escaping (String?, Int?, Error?) -> Void) {
        print("in get monthly workout")
        let now = selectedDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)

        guard let startOfMonth = calendar.date(from: components) else {
            completion(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start of month"]))
            return
        }
        
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        
        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
        let startOfMonthInUTC = dateFormatter.string(from: startOfMonth)
        let endOfMonthInUTC = dateFormatter.string(from: endOfMonth!)
        
        let startOfMonthUTC = dateFormatter.date(from: startOfMonthInUTC)
        let endOfMonthUTC = dateFormatter.date(from: endOfMonthInUTC)
        
        
        print("Start of month: \(startOfMonthUTC!)")
        print("End of month: \(endOfMonthUTC!)")
        
        print("User id: \(user.userid ?? "nil")")
//        let test1 = "888"
//        let test2 = 999
//        completion(test1, test2, nil)
        
        let query = WorkoutData.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfMonthUTC!)
            .where("workout_date" <= endOfMonthUTC!)

        query.find { result in
            switch result {
            case .success(let workoutDataArray):
                print("Workout data array: \(workoutDataArray)")
                let totalTime = workoutDataArray.compactMap { $0.duration }.reduce(0, +)
                let res = self.formatDurationInHours(totalTime)
                let totalCalories = workoutDataArray.compactMap { $0.calories_burnt }.reduce(0, +)
                completion(res, totalCalories, nil)
                print("monthly time duration: \(totalTime), monthly calories burnt: \(totalCalories)")
            case .failure(let error):
                completion(nil, nil, error)
            }
        }
    }

    func getYearlyWorkoutTime(for user: User, completion: @escaping (String?, Int?, Error?) -> Void) {
        print("in get yearly workout")
        let now = selectedDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: now)

        guard let startOfYear = calendar.date(from: components) else {
            completion(nil, nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start of year"]))
            return
        }
        
        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)
        
        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")
        
        let startOfYearInUTC = dateFormatter.string(from: startOfYear)
        let endOfYearInUTC = dateFormatter.string(from: endOfYear!)
        
        let startOfYearUTC = dateFormatter.date(from: startOfYearInUTC)
        let endOfYearUTC = dateFormatter.date(from: endOfYearInUTC)
        
        print("Start of year: \(startOfYearUTC!)")
        print("End of year: \(endOfYearUTC!)")
        
        let query = WorkoutData.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfYearUTC!)
            .where("workout_date" <= endOfYearUTC!)
        
        query.find { result in
            switch result {
            case .success(let workoutDataArray):
                let totalTime = workoutDataArray.compactMap { $0.duration }.reduce(0, +)
                let res = self.formatDurationInHours(totalTime)
                let totalCalories = workoutDataArray.compactMap { $0.calories_burnt }.reduce(0, +)
                completion(res, totalCalories, nil)
                print("monthly time duration: \(totalTime), monthly calories burnt: \(totalCalories)")
            case .failure(let error):
                completion(nil, nil, error)
            }
        }
    }

    
    
    //helper funtion for query checkin times:
    func fetchDailyCheckinTimes(for user: User, completion: @escaping (Int?, Error?) -> Void) {
        let now = selectedDate
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay)

        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        let startOfDayInUTC = dateFormatter.string(from: startOfDay)
        let endOfDayInUTC = dateFormatter.string(from: endOfDay!)

        let startOfDayUTC = dateFormatter.date(from: startOfDayInUTC)
        let endOfDayUTC = dateFormatter.date(from: endOfDayInUTC)

        print("Start of day: \(startOfDayUTC!)")
        print("End of day: \(endOfDayUTC!)")

        let query = WorkoutCount.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfDayUTC!)
            .where("workout_date" <= endOfDayUTC!)

        query.find { result in
            switch result {
            case .success(let workoutCounts):
                let totalCheckins = workoutCounts.reduce(0) { $0 + ($1.checkin_count ?? 0) }
                completion(totalCheckins, nil)
                print("daily checkedin times: \(totalCheckins)")
            case .failure(let error):
                print("Error fetching check-in times: \(error)")
                completion(nil, error)
            }
        }
    }

    // New fetchMonthlyCheckinTimes
    func fetchMonthlyCheckinTimes(for user: User, completion: @escaping (Int?, Error?) -> Void) {
        let now = selectedDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)

        guard let startOfMonth = calendar.date(from: components) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start of month"]))
            return
        }
        
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)

        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        let startOfMonthInUTC = dateFormatter.string(from: startOfMonth)
        let endOfMonthInUTC = dateFormatter.string(from: endOfMonth!)

        let startOfMonthUTC = dateFormatter.date(from: startOfMonthInUTC)
        let endOfMonthUTC = dateFormatter.date(from: endOfMonthInUTC)

        print("Start of month: \(startOfMonthUTC!)")
        print("End of month: \(endOfMonthUTC!)")

        let query = WorkoutCount.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfMonthUTC!)
            .where("workout_date" <= endOfMonthUTC!)

        query.find { result in
            switch result {
            case .success(let workoutCounts):
                let totalCheckins = workoutCounts.reduce(0) { $0 + ($1.checkin_count ?? 0) }
                completion(totalCheckins, nil)
                print("monthly checkedin times: \(totalCheckins)")
            case .failure(let error):
                print("Error fetching check-in times: \(error)")
                completion(nil, error)
            }
        }
    }
    
    
    // New fetchYearlyCheckinTimes
    func fetchYearlyCheckinTimes(for user: User, completion: @escaping (Int?, Error?) -> Void) {
        let now = selectedDate
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: now)

        guard let startOfYear = calendar.date(from: components) else {
            completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to calculate start of year"]))
            return
        }

        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)

        // Convert dates to UTC timezone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "PST")

        let startOfYearInUTC = dateFormatter.string(from: startOfYear)
        let endOfYearInUTC = dateFormatter.string(from: endOfYear!)

        let startOfYearUTC = dateFormatter.date(from: startOfYearInUTC)
        let endOfYearUTC = dateFormatter.date(from: endOfYearInUTC)

        print("Start of year: \(startOfYearUTC!)")
        print("End of year: \(endOfYearUTC!)")

        let query = WorkoutCount.query()
            .where("userid" == user.userid)
            .where("workout_date" >= startOfYearUTC!)
            .where("workout_date" <= endOfYearUTC!)

        query.find { result in
            switch result {
            case .success(let workoutCounts):
                let totalCheckins = workoutCounts.reduce(0) { $0 + ($1.checkin_count ?? 0) }
                completion(totalCheckins, nil)
                print("yearly checkedin times: \(totalCheckins)")
            case .failure(let error):
                print("Error fetching check-in times: \(error)")
                completion(nil, error)
            }
        }
    }

    
    
    

    
    //update workoutdata
    func didSaveWorkoutData() {
        updateWorkoutData()
    }
    
    func updateWorkoutData(){
        if let currentUser = User.current {
            let user = currentUser
            
            switch selectedSegmentIndex {
            case 0: // Daily
                getDailyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            case 1: // Monthly
                getMonthlyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            case 2: // Yearly
                getYearlyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            default:
                break
            }
        } else {
            print("No current user is logged in")
        }
    }
    
 
    //update check-in data
    func checkinViewControllerDidSaveCheckin() {
        updateCheckinTimes()
    }

    func updateCheckinTimes() {
        // Fetch the updated checkin_count from the database
        // and update the text field with the new value
        
       // let currentDate = Date()
        if let currentUser = User.current {
            let user = currentUser
            
            switch selectedSegmentIndex {
            case 0: // Daily
                fetchDailyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }

            case 1: // Monthly
                fetchMonthlyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }

            case 2: // Yearly
                fetchYearlyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }

            default:
                break
            }
        } else {
            print("No current user is logged in")
        }

        
    }

    
    
    /////////////////Collection View Set Up///////////////
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalSquares.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print("in cellForItem")
        print("\(totalSquares[indexPath.item])")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dayOfMonth.text = totalSquares[indexPath.item]
        cell.dayOfMonth.textColor = .white
        
        
        
//        print("SIIII: \(selectedIndexPath)")
//
//        //set up text font
        let font = UIFont(name: "Verdana", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let Bfont = UIFont(name: "Verdana-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        if selectedIndexPath == indexPath {
            cell.dayOfMonth.font = Bfont
        } else {
            cell.dayOfMonth.font = font
        }
        
        //TODO: set backgound color corresonding to workout time
        if(totalSquares[indexPath.item] == ""){
            cell.backgroundColor =  UIColor(red: 235.0/255.0, green: 237.0/255.0, blue: 240.0/255.0, alpha: 0.0)
        }else{
            if(indexPath == selectedIndexPath){
                cell.backgroundColor = UIColor.red
            }else{
                //TODO: decide color here
                cell.backgroundColor = UIColor.systemMint
            }
            
           
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width-50)/7
        let height = width
        //let height = (collectionView.frame.size.height-50)/7
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("in didselectItem")
        
        if totalSquares[indexPath.item] == "" {
            return
        }
        
        let font = UIFont(name: "Verdana", size: 16) ?? UIFont.systemFont(ofSize: 16)
        // Deselect previously selected cell, if any
        if let previousSelectedIndexPath = selectedIndexPath {
            let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? CalendarCell
            previousSelectedCell?.backgroundColor = UIColor.systemMint // Set to default background color
            previousSelectedCell?.dayOfMonth.font = font
        }
        
        let dateComponents = DateComponents(year: currentYear, month: currentMonth, day: Int(totalSquares[indexPath.item]))
        if let date = Calendar.current.date(from: dateComponents) {
            selectedDate = date
            updateWorkoutData()
            updateCheckinTimes()
            let now = Date()
            print("in didselce and selected data is \(selectedDate)")
            print("current time: \(now)")
        }

        // Set the background color for the newly selected cell
        let selectedCell = collectionView.cellForItem(at: indexPath) as? CalendarCell
        selectedCell?.backgroundColor = UIColor.red // Set to selected background color
        let Bfont = UIFont(name: "Verdana-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16)
        selectedCell?.dayOfMonth.font = Bfont
        // Save the index path of the selected cell
        selectedIndexPath = indexPath
        
        //collectionView.reloadData()
    }


    
    //perform segue navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "toTrack" {
              if let trackActivityVC = segue.destination as? TrackActivityViewController {
                  trackActivityVC.delegate = self
              }
          }
        
        if segue.identifier == "toCheckin" {
            if let checkinViewController = segue.destination as? CheckinViewController {
                 checkinViewController.dbdelegate = self
             }
            
        }
    
        
      }
    
    @IBAction func toCheckin(_ sender: Any) {
        performSegue(withIdentifier: "toCheckin", sender: nil)
    }
    
    @IBAction func toTrack(_ sender: Any) {
        performSegue(withIdentifier: "toTrack", sender: nil)
    }
    
    //some button funtions
    @IBAction func previousMonth(_ sender: Any) {
        selectedDate = CalendarHelper().minusMonth(date: selectedDate)
        setMonthView()
        updateWorkoutData()
        updateCheckinTimes()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = CalendarHelper().plusMonth(date: selectedDate)
        setMonthView()
        updateWorkoutData()
        updateCheckinTimes()
    }
    
    override open var shouldAutorotate: Bool{
        return false
    }
    
    
    @IBAction func timeSegmentChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        //TODO: change to selected date
        //let currentDate = Date()

        if let currentUser = User.current {
            let user = currentUser
            
            switch sender.selectedSegmentIndex {
            case 0: // Daily
                fetchDailyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }
                
                getDailyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            case 1: // Monthly
                fetchMonthlyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }
                
                getMonthlyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            case 2: // Yearly
                fetchYearlyCheckinTimes(for: user) { (checkinCount, error) in
                    DispatchQueue.main.async {
                        if let count = checkinCount {
                            self.checkinTimes.text = "\(count)"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                            self.checkinTimes.text = "Error"
                        }
                    }
                }
                
                getYearlyWorkoutTime(for: user) { (totalTimes, calBurnt, error) in
                    DispatchQueue.main.async {
                        if let time = totalTimes, let cal = calBurnt {
                            self.timeSpent.text = "\(time)"
                            self.calBurnt.text = "\(cal)🔥"
                        } else {
                            print("Error: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }

            default:
                break
            }
        } else {
            print("No current user is logged in")
        }

        
    }
    
    
    
    //log out
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
    
    //exit
    @IBAction func unwindToPlaygroundVC(segue: UIStoryboardSegue) {
        
    }

    @IBAction func backToPlaygroundVC(segue: UIStoryboardSegue) {
        
    }


}
