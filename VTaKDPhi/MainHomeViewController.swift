//
//  MainHomeViewController.swift
//  VTaKDPhi
//
//  Created by Zuri Wong on 5/17/18.
//  Copyright © 2018 Zuri Wong. All rights reserved.
//

import UIKit

class MainHomeViewController: UIViewController {

    var timer: Timer!
    var updateCounter: Int!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateCounter = 0
        self.timer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(MainHomeViewController.updateTimer),
            userInfo: nil,
            repeats: true
        )
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc internal func updateTimer(){
        if updateCounter < pageControl.numberOfPages {
            pageControl.currentPage = updateCounter
            // Set Image
            //print("akdphi_\(updateCounter).jpg")
            imageView.image = UIImage(named: "akdphi_\(updateCounter!).jpg")
            updateCounter = updateCounter + 1
        } else {
            updateCounter = 0
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
