//
//  Projects.swift
//  CalDo
//
//  Created by Fabian Jaeger on 29.07.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import Foundation

//var Projects = ["Personal","Work"]

var Projects = [Project]()

 //let Colors = ["#32CD32", "#3DD3E9"]

struct Project {
    var ProjectTitle: String?
    var ProjectColor: String?

static func loadProjects() -> [Project] {
    let Project1 = Project(ProjectTitle: "Personal", ProjectColor: "#32CD32")
    let Project2 = Project(ProjectTitle: "Work", ProjectColor: "#3DD3E9")
    let Project3 = Project(ProjectTitle: "Test", ProjectColor: "4FC2E8")
    let Project4 = Project(ProjectTitle: "Work", ProjectColor: "#3DD3E9")
    let Project5 = Project(ProjectTitle: "Test", ProjectColor: "4FC2E8")
    
    return [Project1, Project2, Project3, Project4, Project5]
}
    

}


