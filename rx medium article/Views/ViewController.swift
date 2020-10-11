//
//  ViewController.swift
//  rx medium article
//
//  Created by Pramodya Abeysinghe on 10/11/20.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView! { didSet { setupTable() } }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let vm = ViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
    }
}

extension ViewController {
    private func addObservers() {
        // TableView
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
        
        vm.breweries.bind(to: tableView.rx.items) { (tableView, row, brewery) -> UITableViewCell in
            let cell = tableView
                .dequeueReusableCell(withIdentifier: BreweryTableViewCell.id,
                                     for: IndexPath(row: row, section: 0)) as! BreweryTableViewCell
            cell.setupCell(with: brewery)
            
            return cell
        }.disposed(by: bag)
        
        vm.breweries.subscribe { [self] _ in
            DispatchQueue.main.async {
                emptyLabel.isHidden = vm.breweries.value.count != 0
            }
        }.disposed(by: bag)
        
        // Segment Controller
        segmentController.rx
            .controlEvent(.valueChanged)
            .asObservable()
            .subscribe{ [self] _ in
                switch segmentController.selectedSegmentIndex {
                case 0: vm.selectedBreweryType.accept(.Micro)
                case 1: vm.selectedBreweryType.accept(.Large)
                case 2: vm.selectedBreweryType.accept(.Contract)
                default: break
                }
            }
            .disposed(by: bag)
        
        vm.selectedBreweryType.asObservable().subscribe { [self] _ in
            fetchBreweries()
        }.disposed(by: bag)
    }
    
    private func fetchBreweries() {
        activityIndicator.startAnimating()
        vm.getBreweries(for: vm.selectedBreweryType.value.rawValue) { [self] (success, message) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
                activityIndicator.stopAnimating()
            }
            
            if success {
                print(vm.selectedBreweryType.value)
            } else {
                print(message ?? "Failed")
            }
        }
    }
    
    private func setupUI() {
    }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
    private func setupTable() {
        tableView.register(BreweryTableViewCell.nib, forCellReuseIdentifier: BreweryTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
