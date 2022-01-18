//
//  FirstViewController.swift
//  toDo
//
//  Created by Артём on 18.01.2022.
//

import UIKit

class FirstViewController: UIViewController,UITableViewDataSource{
    
    

    private let tasksTable:UITableView = {
        let tasksTable = UITableView()
        tasksTable.register(UITableViewCell.self, forCellReuseIdentifier: "taskCell")
        return tasksTable
    }()
    var items = [String]()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tasksTable.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        view.addSubview(tasksTable)
        title = "Tasks list"
        tasksTable.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    
    @objc private func didTapAdd(){
        let alert = UIAlertController(title: "Add item", message: "Add new task", preferredStyle: .alert)
        
        alert.addTextField{ field in
            field.placeholder = "Enter new item"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: {[weak self] (_) in
        if let field = alert.textFields?.first{
            if let text = field.text, !text.isEmpty{
                DispatchQueue.main.async {
                    var curItems =  UserDefaults.standard.stringArray(forKey: "items") ?? []
                    curItems.append(text)
                    UserDefaults.standard.setValue(curItems, forKey: "items")
                    self?.items.append(text)
                    self?.tasksTable.reloadData()
                }
            }
        }
        }))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
            cell.textLabel?.text = items[indexPath.row]
            return cell
        
    }
}
