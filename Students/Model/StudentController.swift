//
//  StudentController.swift
//  Students
//
//  Created by Ben Gohlke on 6/17/19.
//  Copyright © 2019 Lambda Inc. All rights reserved.
//

import Foundation

class StudentController {
    
    private var persistentFileURL: URL? {
        guard let filePath = Bundle.main.path(forResource: "students", ofType: "json") else { return nil }
        return URL(fileURLWithPath: filePath)
    }
    
    
    //Load the JsON from the file and turn it into an array of students
    func loadFromPersistentStore(completion: @escaping([Student])-> Void) {
        
        let bgQueue = DispatchQueue(label: "studentQueue")
        
        bgQueue.asyncAfter(deadline: .now() + 2) {
            
            let fileManager = FileManager.default
            
            guard let url = self.persistentFileURL,
                fileManager.fileExists(atPath: url.path) else {
                    completion([])
                    return
                    
            }
            
            do {
                let data = try Data(contentsOf: url)
                
                let decoder = JSONDecoder()
                //What format is this JSON in, how do you want to decode iit
                let students = try decoder.decode([Student].self, from: data)
                
                completion(students)
                
            } catch {
                print("error loading student from json: \(error)")
                completion([])
                
            }
            
        }
        
    }
    
}
