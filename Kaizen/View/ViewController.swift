//
//  ViewController.swift
//  Kaizen
//
//  Created by Filip Igrutinovic on 20.11.24..
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = SportsViewModel()
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        setupTableView()
        setupBindings()
        viewModel.fetchSports()
        TimerManager.shared.startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor(named: "Background")
        self.navigationItem.title = "App name"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "🐼", style: .plain, target: self, action: #selector(didTapLeftButton))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "⚙️", style: .plain, target: self, action: #selector(didTapRightButton))
    }
    
    @objc private func didTapLeftButton() {
        print("left bar button tapped")
    }
    
    @objc private func didTapRightButton() {
        print("right bar button tapped")
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "Header")
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    private func setupBindings() {
        viewModel.updateSportsList = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    @objc func leftButtonTapped() {
        // Handle the left button action
        print("Left button tapped")
    }
        
    @objc func rightButtonTapped() {
        // Handle the right button action
        print("Right button tapped")
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isCollapse(at: section) ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110 // Adjust as needed for horizontal scrolling
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.configure(with: viewModel.events(of: indexPath.section))
        cell.favouriteTap = { [weak self] eventId in
            self?.viewModel.favoritize(of: eventId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "Header")
        header?.textLabel?.text = viewModel.name(of: section)
        header?.textLabel?.textColor = UIColor(named: "WhiteText")
        header?.contentView.backgroundColor = UIColor(named: "SectionBackground")
        header?.tag = section
            
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSection))
        header?.addGestureRecognizer(tapGesture)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    @objc func toggleSection(gesture: UITapGestureRecognizer) {
        guard let section = gesture.view?.tag else { return }
        viewModel.collapse(of: section)
        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}

