//
//  TableOfCitiesViewController.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 25.04.22.
//

import UIKit

class TableOfCitiesViewController: UIViewController {
    
    var backButton: UIButton!
    var addButton: UIButton!
    private var table = UITableView()
    private let defaults = UserDefaults.standard
    var arrayOfMyCities: [City]? {
        get {
            if let data = defaults.value(forKey: "MyCities") as? Data {
                return try! PropertyListDecoder().decode([City].self, from: data)
            } else {
                return []
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "MyCities")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
        backButton = UIButton(frame: CGRect(x: 5, y: 310, width: 80, height: 30))
        addButton = UIButton(frame: CGRect(x: view.bounds.maxX - 85, y: 310, width: 80, height: 30))
        view.addSubview(backButton)
        view.addSubview(addButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: 300))
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        backButton.backgroundColor = .blue
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
        addButton.backgroundColor = .blue
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(toAdd), for: .touchUpInside)
        
        
    }
    
    @objc func toMain() {
        if self.arrayOfMyCities?.count != 0 {
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    @objc func toAdd() {
        let storyboard = UIStoryboard(name: "AddCityViewController", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController() as! AddCityViewController
        self.present(viewController, animated: true, completion: nil)
    }

}

extension TableOfCitiesViewController: UITableViewDelegate & UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfMyCities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var conf = cell.defaultContentConfiguration()
        
        if let city = arrayOfMyCities?[indexPath.row] {
            conf.text = "\(city.name)" + ", \(city.country)"
            conf.secondaryText = "\(city.state ?? "")"
            
        }
        cell.contentConfiguration = conf
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actionDelete = UIContextualAction(style: .destructive, title: "Remove") {_,_,_ in
            self.arrayOfMyCities?.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
}
