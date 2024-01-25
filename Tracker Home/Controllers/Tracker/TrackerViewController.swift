//
//  TrackerViewController.swift
//  Tracker Home
//
//  Created by Марат Хасанов on 22.12.2023.
//

import UIKit
import CoreData

protocol TrackerViewControllerDelegate: AnyObject {
    func fateOfButton(whre: Bool)
}

//Трекеры
class TrackerViewController: UIViewController, NewCategoryViewControllerDelegate {
    
    let trackerStore = TrackerStore.shared
    let trackerCategoryStore = TrackerCategoryStore.shared
    let trackerRecordStore = TrackerRecordStore.shared
    
    var allTracker: [TrackerCategory] = []
    
    weak var delegate: TrackerViewControllerDelegate?
    
    var selectedDate = Date()
    
    var nowHeaderName: String = ""
    
    var headersName: [String] = ["Домашний уют", "Радостные мелочи"]
    
    var categories: [TrackerCategory] = [TrackerCategory(header: "Домашний уют", tracker: [Tracker(id: UUID(), name: "Бабушка прислала открытку в вотсапе", color: .color16, emoji: "❤️️️️️️️", schedule: [.friday, .monday]), Tracker(id: UUID(), name: "Свидание в январе", color: .udGray, emoji: "💫️️️️️️", schedule: [.friday, .monday])], id: UUID()), TrackerCategory(header: "Радостные мелочи", tracker: [Tracker(id: UUID(), name: "Кошка заслонила камеру на созвоне", color: .udBlue, emoji: "😂", schedule: [.friday, .monday])], id: UUID())]
    
    var visibleTrackers: [TrackerCategory] = []
    
    //Выполненные трекеры
    var completedTrackers: [TrackerRecord] = []
    
    //MARK: Empty and Error Views
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .udBlackDay
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private lazy var emptyImage: UIImageView = {
        let image = UIImage(named: "Empty Image")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: - UI Elements
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.tintColor = .udBlue
        picker.addTarget(self, action: #selector(datePickerSelected), for: .valueChanged)
        return picker
    }()
    
    private lazy var searchBar: UISearchTextField = {
        let search = UISearchTextField()
        search.delegate = self
        search.textColor = .udBlackDay
        search.placeholder = "Поиск"
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerViewControllerCell.self, forCellWithReuseIdentifier: "trackerCell")
        collectionView.register(TrackerViewControllerHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - Functional
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = trackerCategoryStore.getCategories()
        completedTrackers = trackerRecordStore.getCompletedTrackers()
        visibleTrackers = categories
        view.backgroundColor = UIColor.white
        settingNavBarItems()
        setupAllViews()
        setupAllConstraints()
        updateViewController()
        datePickerSelected(datePicker)
    }
        
    @objc func datePickerSelected(_ sender: UIDatePicker) {
        selectedDate = sender.date
        
        let components = datePicker.calendar.dateComponents([.day, .weekday], from: datePicker.date)
        guard let weekday = components.weekday else {
            return
        }
         //Воскресенье - 1, Понедельник - 2
        var searchedCategories: [TrackerCategory] = []
        for category in categories {
            var searchedTrackers: [Tracker] = []
            
            for tracker in category.tracker {
                guard let day = Weekday(rawValue: weekday) else { return }
                if tracker.schedule.contains(day) {
                    searchedTrackers.append(tracker)
                }
            }
            if !searchedTrackers.isEmpty {
                searchedCategories.append(TrackerCategory(header: category.header, tracker: searchedTrackers, id: UUID()))
            }
        }
        visibleTrackers = searchedCategories
        collectionView.reloadData()
        updateViewController()
    }
        
    @objc private func addTracker() {
        let viewController = CreatingTrackers(delegate: self)
        present(UINavigationController(rootViewController: viewController), animated: true)
        print("Добавляй трекер")
    }
    
    //Метод делегата на получение категории
    func categoryName(name: String) {
        print(name)
    }
    
    //Обновление экрана
    private func updateViewController() {
        if visibleTrackers.isEmpty {
            collectionView.isHidden = false
            setupEmptyErrorViews()
            emptyView(true)
        } else {
            setupAllViews()
            setupAllConstraints()
        }
    }
    
    //Настройка navigationBar (кнопка + и datePicker)
    private func settingNavBarItems() {
        let plusButton = UIBarButtonItem(image: UIImage(named: "Add tracker"), style: .plain, target: self, action: #selector(addTracker))
        plusButton.tintColor = .udBlackDay
        
        navigationItem.leftBarButtonItem = plusButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    //Установка всех view
    private func setupAllViews(){
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    //Установка всех констрейнтов
    private func setupAllConstraints(){
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    //Установка пустого/ошибочного экрана (заглушка)
    private func setupEmptyErrorViews() {
        view.addSubview(emptyImage)
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyImage.heightAnchor.constraint(equalToConstant: 80),
            emptyImage.widthAnchor.constraint(equalToConstant: 80),
            emptyImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 230),
            emptyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: 8),
            ])
    }
    
    private func errorView(_ result: Bool) {
        emptyImage.image = UIImage(named: "Error Image")
        emptyLabel.text = "Ничего не найдено"
        
        if result {
            // to show
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
        } else {
            // to dismiss
            emptyImage.isHidden = true
            emptyLabel.isHidden = true
        }
    }
    
    private func emptyView(_ result: Bool) {
        emptyImage.image = UIImage(named: "Empty Image")
        emptyLabel.text = "Что будем отслеживать?"
        
        if result {
            // to show
            emptyImage.isHidden = false
            emptyLabel.isHidden = false
        } else {
            // to dismiss
            emptyImage.isHidden = true
            emptyLabel.isHidden = true
        }
    }
    
    //Установка заглушки при пустом/неверном поиске
    private func setupPlugView() {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            categories = trackerCategoryStore.getCategories()
            visibleTrackers = categories
            errorView(visibleTrackers.isEmpty)
            visibleTrackers.isEmpty ? emptyView(true) : collectionView.reloadData()
            collectionView.reloadData()
            return
        }
        var searchedCategories: [TrackerCategory] = []
        for category in categories {
            var searchedTrackers: [Tracker] = []
            
            for tracker in category.tracker {
                if tracker.name.localizedCaseInsensitiveContains(searchText) {
                    searchedTrackers.append(tracker)
                }
            }
            if !searchedTrackers.isEmpty {
                searchedCategories.append(TrackerCategory(header: category.header, tracker: searchedTrackers, id: UUID()))
            }
        }
        visibleTrackers = searchedCategories
        updateViewController()
        errorView(visibleTrackers.isEmpty)
        collectionView.reloadData()
    }
    
    //Выполнен ли в данный день
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
    }
}

//Расширение SearchBara, возвращает текст работает с экраном
extension TrackerViewController: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setupPlugView()
        collectionView.reloadData()
        return true
    }
}

//MARK: UICollectionViewCell - Header
extension TrackerViewController: UICollectionViewDataSource, TrackerViewControllerCellDelegate {
    func completeTracker(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }

    func uncompleteTracker(id: UUID, indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
            return trackerRecord.id == id && isSameDay
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func reload(id: UUID, indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(id: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row) нажали на ячейку реализация в дальнейшем мб")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {        return visibleTrackers.count
    }
    
    //Кол-во ячеек в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleTrackers[section].tracker.count
    }
    
    //Сама ячейка для заданной позиции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "trackerCell", for: indexPath) as? TrackerViewControllerCell else {
            preconditionFailure("Ошибка с ячейкой")
        }
        let tracker = visibleTrackers[indexPath.section].tracker[indexPath.row]
        let completedDay = completedTrackers.filter { $0.id == tracker.id}.count
        let completedToday = isTrackerCompletedToday(id: tracker.id)
        cell.setupData(traker: tracker, dayCount: completedDay, isCompletedToday: completedToday, indexPath: indexPath)
        cell.delegate = self
        cell.selectedDate = selectedDate
        return cell
    }
}

//Для управления расположением и размерами элементов
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    
    //Метод чтобы мы могли возвращать хедер для каждой секции
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var id: String
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! TrackerViewControllerHeader
        view.titleLabel.text = visibleTrackers.isEmpty ? "" : visibleTrackers[indexPath.section].header
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionInsets = UIEdgeInsets(top: 16, left: 28, bottom: 12, right: 28)
        return CGSize(width: collectionView.bounds.width - sectionInsets.left - sectionInsets.right, height: 18)
    }
    
    //Высота и ширина коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    //Отступы от краев коллекции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 16, bottom: 16, right: 16)
    }
    
    //Горизонтальные отступы между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    //Вертикальные отступы между ячейками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//Делегат на добавление нового трекера
extension TrackerViewController: CreatingTrackersDelegate {
    func createNewTracker(header: String, tracker: Tracker) {
        let newTracker = TrackerCategory(header: header, tracker: [tracker], id: UUID())
        
        if let index = headersName.firstIndex(of: header) {
            categories[index].tracker.append(tracker)
            print("Есть в массиве, надо добавить ТОЛЬКО ТРЕКЕР")
        } else {
            print("Нету надо добавить ПОЛНОСТЬЮ")
            trackerCategoryStore.saveCategoryToCoreData(newTracker)
            headersName.append(header)
            categories.append(newTracker)
        }
        visibleTrackers = categories
        collectionView.reloadData()
        updateViewController()
    }
}

