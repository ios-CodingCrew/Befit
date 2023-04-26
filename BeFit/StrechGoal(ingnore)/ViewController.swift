//////
//////  ViewController.swift
//////  BeFit
//////
//////  Created by Evelyn on 4/10/23.
//////
/////
/////
//
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var monthLabelsCollection: UICollectionView!
    
    private let monthData: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(gridLayout, animated: false)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ContributionCell.self, forCellWithReuseIdentifier: ContributionCell.reuseIdentifier)
        
        let monthLabelsLayout = UICollectionViewFlowLayout()
        monthLabelsCollection.setCollectionViewLayout(monthLabelsLayout, animated: false)
        monthLabelsCollection.dataSource = self
        monthLabelsCollection.delegate = self
        monthLabelsCollection.register(MonthLabelCell.self, forCellWithReuseIdentifier: MonthLabelCell.reuseIdentifier)
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView {
            return 7 // 7 rows for 7 days in a week
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return 52 // 52 columns to cover 365 days
        }
        return monthData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContributionCell.reuseIdentifier, for: indexPath) as? ContributionCell else {
                fatalError("Unable to dequeue GridCell")
            }
            cell.configure(with: 0) // Set the default intensity of the grid to 0, which maps to light gray
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthLabelCell.reuseIdentifier, for: indexPath) as? MonthLabelCell else {
                fatalError("Unable to dequeue MonthLabelCell")
            }
            cell.configure(with: monthData[indexPath.item])
            return cell
        }
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView {
            let numberOfColumns = 52
            let cellWidth = max((collectionView.bounds.width - CGFloat(numberOfColumns - 1) * 4) / CGFloat(numberOfColumns), 0)
            return CGSize(width: cellWidth, height: cellWidth)
        } else {
            return CGSize(width: 45, height: 20) // Adjust the size according to your requirements
        }
    }

}


//import UIKit
//
//class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    private var scrollView: UIScrollView!
//    private var collectionView: UICollectionView!
//    private var monthLabelsCollectionView: UICollectionView!
//
//    // Sample data
//    let workoutData: [[Int]] = [
//        [0, 1, 2, 3, 0, 0],
//        [1, 2, 3, 0, 1, 2],
//        [2, 3, 0, 1, 2, 3],
//        [3, 0, 1, 2, 3, 0],
//        [0, 1, 2, 3, 0, 1]
//    ]
//
//    // Sample month labels
//    let monthData: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "June", "July", "Aug","Spet", "Oct"]
//
//    override func viewDidLoad() {
//         super.viewDidLoad()
//         view.backgroundColor = .white
//
//         setupScrollView()
//         setupCollectionView()
//         setupMonthLabelsCollectionView()
//
//         scrollView.addSubview(monthLabelsCollectionView)
//         scrollView.addSubview(collectionView)
//     }
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        let layout = UICollectionViewFlowLayout()
////        layout.minimumInteritemSpacing = 4
////        layout.minimumLineSpacing = 4
////
////        let monthLayout = UICollectionViewFlowLayout()
////        monthLayout.scrollDirection = .horizontal
////        monthLayout.minimumInteritemSpacing = 4
////
////        scrollView = UIScrollView()
////        view.addSubview(scrollView)
////
////        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
////        collectionView.dataSource = self
////        collectionView.delegate = self
////        collectionView.register(ContributionCell.self, forCellWithReuseIdentifier: ContributionCell.reuseIdentifier)
////        collectionView.isScrollEnabled = false
////        scrollView.addSubview(collectionView)
////
////        monthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: monthLayout)
////        monthCollectionView.dataSource = self
////        monthCollectionView.delegate = self
////        monthCollectionView.register(MonthLabelCell.self, forCellWithReuseIdentifier: MonthLabelCell.reuseIdentifier)
////        monthCollectionView.isScrollEnabled = false
////        scrollView.addSubview(monthCollectionView)
////    }
//
//    override func viewDidLayoutSubviews() {
//          super.viewDidLayoutSubviews()
//
//          let maxColumns = workoutData.reduce(0) { max($0, $1.count) }
//          let cellWidth = (collectionView.bounds.width - CGFloat(maxColumns - 1) * 4) / CGFloat(maxColumns)
//          let contentWidth = CGFloat(maxColumns) * cellWidth + CGFloat(maxColumns - 1) * 4
//          scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
//
//          monthLabelsCollectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 30)
//          collectionView.frame = CGRect(x: 0, y: 40, width: view.bounds.width, height: view.bounds.height - 40)
//          scrollView.frame = view.bounds
//      }
//
////    private func updateContentSize() {
////        let collectionViewWidth = collectionView.contentSize.width
////        let monthCollectionViewWidth = monthCollectionView.contentSize.width
////
////        let contentWidth = max(collectionViewWidth, monthCollectionViewWidth)
////        scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.bounds.height)
////    }
////
//    private func setupScrollView() {
//         scrollView = UIScrollView()
//         scrollView.showsHorizontalScrollIndicator = true
//         scrollView.alwaysBounceHorizontal = true
//         view.addSubview(scrollView)
//     }
//
//    private func setupMonthLabelsCollectionView() {
//           let layout = UICollectionViewFlowLayout()
//           layout.scrollDirection = .horizontal
//           layout.minimumLineSpacing = 4
//           layout.minimumInteritemSpacing = 4
//
//           monthLabelsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//           monthLabelsCollectionView.register(MonthLabelCell.self, forCellWithReuseIdentifier: MonthLabelCell.reuseIdentifier)
//           monthLabelsCollectionView.dataSource = self
//           monthLabelsCollectionView.delegate = self
//           monthLabelsCollectionView.backgroundColor = .clear
//       }
//
//    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal // Set scroll direction to horizontal
//        layout.minimumLineSpacing = 4
//        layout.minimumInteritemSpacing = 4
//
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(ContributionCell.self, forCellWithReuseIdentifier: ContributionCell.reuseIdentifier)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.backgroundColor = UIColor.lightGray
//    }
//
//
//    // UICollectionViewDataSource
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if collectionView == self.collectionView {
//            return workoutData.count
//        } else {
//            return 1
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == self.collectionView {
//            return workoutData[section].count
//        } else {
//            return monthData.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView == self.collectionView {
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContributionCell.reuseIdentifier, for: indexPath) as! ContributionCell
//               cell.configure(with: workoutData[indexPath.section][indexPath.item])
//               return cell
//           } else {
//               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MonthLabelCell.reuseIdentifier, for: indexPath) as! MonthLabelCell
//               cell.configure(with: monthData[indexPath.item])
//               return cell
//           }
//    }
//
//    // UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView == self.collectionView {
//            let width = (collectionView.bounds.width - CGFloat(workoutData[indexPath.section].count - 1) * 4) / CGFloat(workoutData[indexPath.section].count)
//            return CGSize(width: width, height: width)
//        } else {
//            let width = collectionView.bounds.width / CGFloat(monthData.count)
//            return CGSize(width: width, height: collectionView.bounds.height)
//        }
//    }
//
//
//}

//
//
//
//import UIKit
//
//class ViewController: UIViewController {
//
//
//
//
////    @IBOutlet weak var scrollView: UIScrollView!
////
//    override func viewDidLoad() {
////           super.viewDidLoad()
////
////           let gridView = UIView()
////           gridView.backgroundColor = UIColor.white
////
////           let gridSize = CGSize(width: 52, height: 7)
////           let gridItemSize = CGSize(width: 15, height: 15)
////           let spacing: CGFloat = 5
////
////           for row in 0..<Int(gridSize.height) {
////               for col in 0..<Int(gridSize.width) {
////
////                   let gridItemView = UIView(frame: CGRect(x: col * (Int(gridItemSize.width) + Int(spacing)), y: row * (Int(gridItemSize.height) + Int(spacing)), width: Int(gridItemSize.width), height: Int(gridItemSize.height)))
////
////                  gridItemView.backgroundColor = UIColor.lightGray
////
////
////                   gridView.addSubview(gridItemView)
////               }
////           }
////
////           scrollView.addSubview(gridView)
////           scrollView.contentSize = gridView.bounds.size
////       }
////       let contentView = UIView()
////       let cellSize: CGFloat = 20.0
////       let gridSize = CGSize(width: 52, height: 7)
////
////       override func viewDidLoad() {
////           super.viewDidLoad()
////
////           // Set up scroll view
////           scrollView.translatesAutoresizingMaskIntoConstraints = false
////           scrollView.delegate = self
////           scrollView.showsHorizontalScrollIndicator = true
////           view.addSubview(scrollView)
////
////           NSLayoutConstraint.activate([
////               scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
////               scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
////               scrollView.topAnchor.constraint(equalTo: view.topAnchor),
////               scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
////           ])
////
////           // Set up content view
////           contentView.translatesAutoresizingMaskIntoConstraints = false
////           scrollView.addSubview(contentView)
////
////           NSLayoutConstraint.activate([
////               contentView.widthAnchor.constraint(equalToConstant: cellSize * gridSize.width),
////               contentView.heightAnchor.constraint(equalToConstant: cellSize * gridSize.height),
////               contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
////               contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
////               contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
////               contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
////           ])
////
////           // Add cells to content view
////           for y in 0..<Int(gridSize.height) {
////               for x in 0..<Int(gridSize.width) {
////                   let cell = UIView()
////                   cell.backgroundColor = UIColor.lightGray
////                   cell.translatesAutoresizingMaskIntoConstraints = false
////                   contentView.addSubview(cell)
////
////                   NSLayoutConstraint.activate([
////                       cell.widthAnchor.constraint(equalToConstant: cellSize),
////                       cell.heightAnchor.constraint(equalToConstant: cellSize),
////                       cell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellSize * CGFloat(x)),
////                       cell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: cellSize * CGFloat(y)),
////                   ])
////               }
////           }
////       }
////
////       func viewForZooming(in scrollView: UIScrollView) -> UIView? {
////           return contentView
//}
//
//    //    override func viewDidLoad() {
////            super.viewDidLoad()
////
////            let squareSize: CGFloat = 20
////            let spacing: CGFloat = 5
////            let gridSize = 7
////            let containerWidth = CGFloat(gridSize) * squareSize + CGFloat(gridSize - 1) * spacing
////            let containerHeight = CGFloat(gridSize) * squareSize + CGFloat(gridSize - 1) * spacing
////
////            let container = UIView(frame: CGRect(x: 0, y: 0, width: containerWidth, height: containerHeight))
////           // container.center = view.center
////            let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
////                let statusBarHeight = UIApplication.shared.statusBarFrame.height
////                container.frame.origin.y = navigationBarHeight + statusBarHeight
////
////            for i in 0..<gridSize {
////                for j in 0..<gridSize {
////                    let square = UIView(frame: CGRect(x: CGFloat(j) * (squareSize + spacing), y: CGFloat(i) * (squareSize + spacing), width: squareSize, height: squareSize))
////                    square.backgroundColor = UIColor.lightGray
////                    container.addSubview(square)
////                }
////            }
////
////            view.addSubview(container)
////        }
//
//
//}
//
