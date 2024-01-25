//
//  NewScheduleViewController.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 09.01.2024.
//

import UIKit

protocol NewScheduleViewControllerDelegate: AnyObject {
    func getDay(day: [Weekday])
}

//Расписание
class NewScheduleViewController: UIViewController {
    
    var schedule: [Weekday] = []
    
    weak var delegate: NewScheduleViewControllerDelegate?
    
    init(delegate: NewScheduleViewControllerDelegate?) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let weekDay: [String] = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(ScheduleTableViewCell.self, forCellReuseIdentifier: "ScheduleTableViewCell")
        table.separatorStyle = .singleLine
        table.separatorColor = .udGray
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.backgroundColor = .udWhiteDay
        table.isScrollEnabled = false
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        let cgColor = UIColor.udWhiteDay.cgColor
        table.layer.borderColor = cgColor
        table.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let readyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .udBlackDay
        button.addTarget(self, action: #selector(readyButtonClicked), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .udWhiteDay
        tableView.delegate = self
        tableView.dataSource = self
        setupAllView()
        print("Расписание")
    }
    
    @objc
    private func readyButtonClicked() {
        dismiss(animated: true)
        self.delegate?.getDay(day: schedule)
        print("Готово")
    }
    
    @objc
    private func switcherChanged(_ sender: UISwitch) {
        var dayNumber = sender.tag + 2
        if sender.isOn {
            if dayNumber > 7 {
                dayNumber = 1
            }
            schedule.append(Weekday(rawValue: dayNumber)!)
        } else {
            schedule.removeAll { $0.rawValue == dayNumber}
        }
        print("\(sender.tag)")
        print("\(sender.isOn ? "On" : "Off")")
    }
    
    private func setupAllView() {
        view.addSubview(tableView)
        view.addSubview(readyButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -47),
        
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)])
    }
}

extension NewScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NewScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ScheduleTableViewCell")
        }
        cell.textLabel?.text = weekDay[indexPath.row]
        let switcher = UISwitch(frame: .zero)
        switcher.setOn(false, animated: true)
        switcher.tag = indexPath.row
        switcher.onTintColor = .udBlue
        switcher.addTarget(self, action: #selector(switcherChanged), for: .valueChanged)
        cell.backgroundColor = .udBackground
        cell.accessoryView = switcher
        
        let height = tableView.bounds.height / 7
        print(height)
        
        cell.heightAnchor.constraint(equalToConstant: height).isActive = true
        return cell
    }
}
