//
//  TableOfCitiesViewController.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 25.04.22.
//

import UIKit

class TableOfCitiesViewController: UIViewController {
    
    var myCitiesLabel: UILabel!
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
        
        myCitiesLabel = UILabel()
        backButton = UIButton()
        addButton = UIButton()
        
        myCitiesLabel.translatesAutoresizingMaskIntoConstraints = false
        table.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(myCitiesLabel)
        view.addSubview(table)
        view.addSubview(backButton)
        view.addSubview(addButton)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCitiesLabel.text = "My Cities"
        myCitiesLabel.font = UIFont.systemFont(ofSize: 40)
        myCitiesLabel.textAlignment = .center
        
        table.delegate = self
        table.dataSource = self
        
        backButton.backgroundColor = .blue
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        
        addButton.backgroundColor = .blue
        addButton.setTitle("Add", for: .normal)
        addButton.addTarget(self, action: #selector(toAdd), for: .touchUpInside)
        
        setElements()
        
    }
    
    private func setElements() {
        NSLayoutConstraint.activate([
        
            myCitiesLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            myCitiesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myCitiesLabel.widthAnchor.constraint(equalToConstant: 200),
            myCitiesLabel.heightAnchor.constraint(equalToConstant: 60),
            
            table.widthAnchor.constraint(equalTo: view.widthAnchor),
            table.heightAnchor.constraint(equalToConstant: view.bounds.height - 250),
            table.topAnchor.constraint(equalTo: myCitiesLabel.bottomAnchor),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: table.bottomAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            
            view.trailingAnchor.constraint(equalTo: addButton.trailingAnchor, constant: 10),
            addButton.topAnchor.constraint(equalTo: backButton.topAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 50)
            
        ])
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
