//
//  FeedViewController.swift
//  Outstagram
//
//  Created by 백래훈 on 2022/10/19.
//

import UIKit
import SnapKit

final class FeedViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "FeedTableViewCell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupTableView()
        
    }
    
    private lazy var imagePickerViewController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        return imagePickerController
    }()
    
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell
        cell?.selectionStyle = .none
        cell?.setup()
        
        return cell ?? UITableViewCell()
    }
}

extension FeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectImage: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectImage = editedImage
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectImage = originImage
        }
        
        picker.dismiss(animated: true) { [weak self] in
            let uploadViewController = UploadViewController(uploadImage: selectImage ?? UIImage())
            let navigationController = UINavigationController(rootViewController: uploadViewController)
            navigationController.modalPresentationStyle = .fullScreen
            
            self?.present(navigationController, animated: true)
        }
    }
}

private extension FeedViewController {
    func setupNavigationBar() {
        navigationItem.title = "Outstagram"
        
        let uploadButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.app"),
            style: .plain,
            target: self,
            action: #selector(didTapUploadButton)
        )
        navigationItem.rightBarButtonItem = uploadButton
    }
    
    @objc func didTapUploadButton() {
        present(imagePickerViewController, animated: true)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
