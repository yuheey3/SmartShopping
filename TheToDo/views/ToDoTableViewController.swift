//
//  ToDoTableViewController.swift
//  TheToDo
//
//  Created by Jigisha Patel on 2021-02-09.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    private var taskList = Task.getInitialData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.tableView.rowHeight = 70
        
        let btnAddTask = UIBarButtonItem(title: "Add Task", style: .plain, target: self, action: #selector(addNewTask))
        
        self.navigationItem.setRightBarButton(btnAddTask, animated: true)
        
        self.setUpLongPressGesture()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.taskList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath) as! ToDoCell

        // Configure the cell...
        
        if indexPath.row < taskList.count{
            let task = taskList[indexPath.row]
            
            cell.lblTitle.text = task.title
            cell.lblDetail.text = task.subtitle
            
//            task.done.toggle()
////            task.done = !task.done
            
            let accessory: UITableViewCell.AccessoryType = task.done ? .checkmark : .none
            
            cell.accessoryType = accessory
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if (indexPath.row < self.taskList.count){
            //ask for the confirmation first
            
            self.deleteTaskFromList(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if indexPath.row < self.taskList.count{
            let task = self.taskList[indexPath.row]
            task.done.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc
    func addNewTask() {
        //ask for title and detail of the task
        self.displayCustomAlert(isNewTask: true, indexPath: nil, title: "New Task", message: "Enter details for new task")
        //add to the list of tasks
    }
    
    private func displayCustomAlert(isNewTask : Bool, indexPath: IndexPath?, title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if (isNewTask){
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "What do you want to do?"
            }
            alert.addTextField{(textField: UITextField) in
                textField.placeholder = "Provide the details"
                textField.keyboardType = .default
                textField.autocorrectionType = .yes
            }
        }else if (indexPath != nil){
            alert.addTextField{(textField: UITextField) in
                textField.text = self.taskList[indexPath!.row].title
            }
            
            alert.addTextField{(textField: UITextField) in
                textField.text = self.taskList[indexPath!.row].subtitle
            }
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if let titleText = alert.textFields?[0].text, let subtitleText = alert.textFields?[1].text{
                
                if (isNewTask){
                    self.addTaskToList(title: titleText, subtitle: subtitleText)
                }else if (indexPath != nil){
                    self.updateTaskInList(indexPath: indexPath!, title: titleText, subtitle: subtitleText)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    private func addTaskToList(title: String, subtitle: String){
        //index for the new row
        let newIndex = taskList.count
        
        self.taskList.append(Task(title: title, subtitle: subtitle))
        
        //to insert row into table
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .bottom)
        tableView.reloadData()
    }
    
    private func deleteTaskFromList(indexPath: IndexPath){
        //remove task from the list
        self.taskList.remove(at: indexPath.row)
        
        //delete the table row
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        self.tableView.reloadData()
    }
    
    private func updateTaskInList(indexPath: IndexPath, title: String, subtitle: String){
        self.taskList[indexPath.row].title = title
        self.taskList[indexPath.row].subtitle = subtitle
        
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func setUpLongPressGesture(){
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        
        longPressGesture.minimumPressDuration = 1.0 //1 second
        
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc
    private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended{
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint){
                
                self.displayCustomAlert(isNewTask: false, indexPath: indexPath, title: "Edit Task", message: "Please provide the updated details")
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
