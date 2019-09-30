//
//  MainViewController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import UIKit

class StudentsViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sortSelector: UISegmentedControl!
    @IBOutlet weak var filterSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let studentController = StudentController()
    
    private var students: [Student] = []
    
    private var filteredAndSortedStudents: [Student] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        studentController.loadFromPersistentStore { (students) in
            //Anything in this closure will get run only after LFPS calls its completion
            
            DispatchQueue.main.async {
                
            
            self.students = students
            self.updateDataSource()
            }
        }
        
    }
    
    // MARK: - Action Handlers
    
    @IBAction func sort(_ sender: UISegmentedControl) {
        updateDataSource()
        
    }
    
    @IBAction func filter(_ sender: UISegmentedControl) {
        updateDataSource()
    }
    
    
    func updateDataSource() {
        
        var updatedStudents: [Student]
        
        //Filter then sort
        
        
        switch filterSelector.selectedSegmentIndex {
            
        case 1:
            updatedStudents = students.filter({ (student) -> Bool in
                return student.course == "iOS"
            })
            
            
        case 2:
            
            updatedStudents = students.filter({$0.course == "Web"})
            
        case 3:
            updatedStudents = students.filter({$0.course == "UX"})
            
        default:
            updatedStudents = students
            
        }
        
        if sortSelector.selectedSegmentIndex == 0 {
            updatedStudents = updatedStudents.sorted(by: { (student1, student2) -> Bool in
                return student1.firstName < student2.firstName
            })
        } else {
            updatedStudents = updatedStudents.sorted(by: {$0.lastName < $1.lastName})
        }
        
        filteredAndSortedStudents = updatedStudents
        tableView.reloadData()
        
    }
    
    // MARK: - Private
}

extension StudentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredAndSortedStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell", for: indexPath)
        
        let student = filteredAndSortedStudents[indexPath.row]
        
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.course
        
        return cell
    }
}
