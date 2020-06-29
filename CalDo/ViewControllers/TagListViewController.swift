//
//  TagListViewController.swift
//  CalDo
//
//  Created by Fabian Jaeger on 25.08.19.
//  Copyright © 2019 CalDo. All rights reserved.
//

import UIKit
import TagListView

var AllTags = [tag]()
var PreviouslySelectedTags = [tag]()

protocol ChooseTagsViewControllerDelegate: class {
    func TagDataReceived(tagsSelected: [tag])
}

class TagListViewController: UIViewController, TagListViewDelegate{
    
    weak var delegate: ChooseTagsViewControllerDelegate?

    
    // Selected Tags that will be transferred to the New Task View Controller 
    var TagArray = [tag]()
    
    @IBAction func SaveButtonPressed(_ sender: Any) {
        
        let selectedTagView = TagListView.selectedTags()
        
// ---------- Extracting Information from selectedTagView and append it in two arrays, one for the color one for the label.
        
        if selectedTagView.count != 0{
            var tagLabels = [String]()
            var tagColors = [UIColor]()
            var i = 0
            while i < selectedTagView.count{
                let taglabel = selectedTagView[i].titleLabel!.text!
                let tagColor = selectedTagView[i].borderColor!
                let newtag = tag(tagLabel: taglabel, tagColor: tagColor)
                tagLabels.append(taglabel)
                tagColors.append(tagColor)
                TagArray.append(newtag)
                i += 1
            }
            
            print(tagLabels)
            print(tagColors)
//            print(TagArray[1].tagLabel!)
            
            delegate?.TagDataReceived(tagsSelected: TagArray)
        }
        
        else {
                // do nothing
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var EditButton: UIButton!
    
    @IBOutlet weak var TagListView: TagListView!

    @IBOutlet weak var BackgroundView: UIView!
    
    @IBAction func AddTag(_ sender: Any) {
        if AddTagTextField.text! != "" {
            let tagView =  TagListView.addTag(AddTagTextField.text!)
            let randomnumber = Int.random(in: 0...TagColors.count-1)
            let randomcolor = TagColors[randomnumber]
            tagView.textColor = UIColor(hexString: randomcolor)
            let AppendTag = tag(tagLabel: AddTagTextField.text!, tagColor: UIColor(hexString: randomcolor))
            print(AppendTag)
            AllTags.append(AppendTag)
            print(AllTags)
            AddTagTextField.text = ""
        
            
    // Trying to create a stored data platform for tags
//            let tagColor = tagView.textColor
//            let tagLabel = tagView.titleLabel?.text!
//            let tag: tag
//            tag.tagColor = tagColor
//            tag.tagLabel = tagLabel
//            AllTags.append(tag)
        }
    }
    

    
    
    @IBAction func EditButtonPressed(_ sender: Any) {
        func editButtonPressed() {
            TagListView.enableRemoveButton = true
            TagListView.removeButtonIconSize = 3
            TagListView.removeIconLineWidth = 2
            TagListView.removeIconLineColor = UIColor(hexFromString: "ED5465")
            EditButton.setTitle("Done", for: .selected)
            TagListView.enableRemoveButton = true
        }
        editButtonPressed()
    }
    @IBOutlet weak var BackgroundViewAdd: UIView!

    @IBOutlet weak var AddTagTextField: UITextField!

    @IBAction func Dismiss(_ sender: UITextField) {
         sender.resignFirstResponder()
    }
    let TagColors = ["98D468","ED5465","82DAE0","4FC2E8","B0E5CA", "F5BA41"]
    
    
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        TagListView.removeTag(title) //Possibly improve, since this deletes all tags with specific title
        
        
        // Implement method to delete the tag from AllTags Array, implement function to search for the tag title
        
    }
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        TagListView.tagSelectedBackgroundColor = UIColor(hexFromString: "#D8D8D8")
        
        let color = tagView.textColor
    
        
        
        if tagView.isSelected == false{
            tagView.borderColor = color
            tagView.isSelected = true
            tagView.selectedTextColor = UIColor.white

//            tagView.layer.shadowOpacity = 0.8
//            tagView.layer.shadowRadius = 50
//            tagView.layer.shadowColor = UIColor.darkGray.cgColor
        }
        else {
            tagView.isSelected = false
            tagView.textColor = color
        }
    
    }
// The remove Icon gets initialised for every tag that is added after the edit button has pressed. I have to find a way to reload the preexisting Tags in the view. The issue seems tto be the tagView instance itself that doesnt load the tag remove icon, cause the TagListView seems to allocate space for the Icon
    
    
    override func viewDidLoad() {
        
            var i = 0
            let iterator = AllTags.count
            while i < iterator {
                let tagView =  TagListView.addTag(AllTags[i].tagLabel)
                // Color of Tags doesnt seem to be adde
                tagView.textColor = AllTags[i].tagColor
                i += 1
            }
        
        NotificationCenter.default.addObserver(self, selector: #selector(TagListViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(TagListViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        TagListView.enableRemoveButton = false
        
        TagListView.borderWidth = 0
        
        TagListView.delegate = self
        
        BackgroundViewAdd.layer.cornerRadius
         = 20
        BackgroundViewAdd.layer.backgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.6).cgColor
        BackgroundView.layer.cornerRadius = 20
        BackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        BackgroundView.layer.shadowRadius = 50
        BackgroundView.layer.shadowOpacity = 0.20
//        TagListView.textColor = UIColor(hexFromString: "606873")
        
        TagListView.textFont = UIFont(name: "HelveticaNeue-Medium", size: 17)!
        TagListView.tagBackgroundColor = UIColor(hexFromString: "F0F2F4", alpha: 0.8)
        TagListView.alignment = .center // possible values are .left, .center, and .right
        
        
//
//        TagListView.addTag("TagListView")
//        TagListView.addTags(["Add", "two", "tags"])
//
//        TagListView.insertTag("This should be the second tag", at: 1)
        
        BackgroundView.layer.cornerRadius = 20
        super.viewDidLoad()
        AddTag((Any).self)
        // Do any additional setup after loading the view.
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
    guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.BackgroundView.frame.origin.y == 0 {
            self.BackgroundView.frame.origin.y -= keyboardFrame.height
            }
        }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += keyboardFrame.height
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
     
     

}
*/
    
}
