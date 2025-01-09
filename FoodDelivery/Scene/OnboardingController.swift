//
//  OnboardingController.swift
//  FoodDelivery
//
//  Created by PC1562 on 9/1/25.
//

import UIKit
import SnapKit

class OnboardingController: UIViewController {
    
    private var imageNames: [String] = ["", "", "", ""]
    
    private lazy var clvOnboard: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let clv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clv.delegate = self
        clv.dataSource = self
        clv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return clv
    }()
    
    private lazy var lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x32343E)
        label.text = "All your favorites"
        label.font = Font.bold(24)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    private lazy var lblSubTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x646982)
        label.text = "Get all your loved foods in one once place, you just place the orer we do the rest"
        label.font = Font.regular(16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = imageNames.count
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor(rgb: 0xFF7622)
        page.pageIndicatorTintColor = UIColor(rgb: 0xFFE1CE)
        return page
    }()
    
    private lazy var btnNext: UIButton = {
        let button = UIButton()
        button.setTitle("Start Ordering", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = Font.bold(14)
        button.backgroundColor = UIColor(rgb: 0xFF7622)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private lazy var btnSkip: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x646982), for: .normal)
        button.titleLabel?.font = Font.bold(16)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        self.view.addSubview(self.clvOnboard)
        self.view.addSubview(self.lblTitle)
        self.view.addSubview(self.lblSubTitle)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.btnNext)
        self.view.addSubview(self.btnSkip)
        
        self.clvOnboard.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(55)
            make.right.equalToSuperview()
            make.width.equalTo(self.clvOnboard.snp.height).multipliedBy(240/292)
        }
        
        self.lblTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(44)
        }
        
        self.lblSubTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(16)
        }
        
        self.btnSkip.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.width.equalTo(50)
            make.height.equalTo(self.btnNext.snp.height)
            make.centerX.equalTo(self.btnNext.snp.centerX)
        }
        
        self.btnNext.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(self.btnNext.snp.width).multipliedBy(62/327)
            make.bottom.equalTo(self.btnSkip.snp.top).offset(-12)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.btnNext.snp.top).offset(-60)
        }
    }
}

extension OnboardingController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//class OnboardingControllerViewCell: UICollectionViewCell {
//    static let identifier = String(describing: OnboardingControllerViewCell.self)
//    
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 18, weight: .bold)
//        label.textColor = .black
//        label.textAlignment = .center
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.awakeFromNib()
//    }
//    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
