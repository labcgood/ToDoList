//
//  ViewController.swift
//  Demo
//
//  Created by Labe on 2024/6/5.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var trashButton: UIButton!
    
    // 產生清單、設定一有更動就儲存
    var todoList = [ToDoItem]() {
        didSet {
            ToDoItem.save(item: todoList)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 設定tableView的dataSource
        tableView.dataSource = self
        
        // 載入頁面時呼叫儲存的資料
        if let items = ToDoItem.load() {
            self.todoList = items
        }
        
        // 設定加入清單、刪除清單的button樣式
        let config = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .large)
        let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: config)
        let trashImage = UIImage(systemName: "trash.fill", withConfiguration: config)
        addButton.setImage(addImage, for: .normal)
        trashButton.setImage(trashImage, for: .normal)
        
    }
    
    // TableView設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else { fatalError() }
        let item = todoList[indexPath.row]
        cell.update(with: item)
        return cell
    }
    
    // 變更清單狀態
    // 利用convert來取得所點選的位置，用來得知被點選的cell是哪一個，以改變當前清單的isFinish屬性儲存起來
    @IBAction func check(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath = tableView.indexPathForRow(at: point) {
            todoList[indexPath.row].isFinish = !todoList[indexPath.row].isFinish
        }
        tableView.reloadData()
    }
    
    
    // 添加新的清單(使用alertController)
    @IBAction func addTodoItem(_ sender: Any) {
        let alertController = UIAlertController(title: "新增清單", message: "", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "輸入內容"
        }
        
        // 使用weak Reference來打破循環引用，避免產生記憶體洩漏問題(詳見補充)
        let addAction = UIAlertAction(title: "加入", style: .default) { [weak self] (_) in
            if let titleField = alertController.textFields?[0],
               let title = titleField.text, !title.isEmpty {
                // 把新增的清單加在第一個，清單的增加是由上往下(最新的會在最上面)
                self?.todoList.insert(ToDoItem(title: title, isFinish: false), at: 0)
                self?.tableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // 刪除清單(所有已完成的)
    // 使用array的filter方法來把沒有被標記完成的項目挑起來，設定回todoList並更新畫面
    @IBAction func deleteFinishList(_ sender: Any) {
        todoList = todoList.filter { !$0.isFinish }
        tableView.reloadData()
    }
    
    
    // 删除清單(單項)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

