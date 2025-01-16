//
//  OnboardingController.swift
//  FoodDelivery
//
//  Created by PC1562 on 9/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

struct OnboardingData {
    let imageName: String
    let title: String
    let subtitle: String
    
    static let mock: [OnboardingData] = [
        .init(imageName: "intro-1", title: "Welcome to Foodie's Paradise", subtitle: "Explore top-rated restaurants and order in minutes"),
        .init(imageName: "intro-2", title: "Discover Deliciousness Delivered", subtitle: "Satisfy your cravings with our curated menu options"),
        .init(imageName: "intro-3", title: "Your Favorite Meals, Just a Tap Away", subtitle: "Convenient, quick, and always fresh—right at your door"),
        .init(imageName: "intro-4", title: "Fresh Food, Fast Delivery", subtitle: "From breakfast to late-night bites, we’ve got you covered"),
    ]
}

class OnboardingController: BaseViewController {
    
    private var datas: [OnboardingData] = OnboardingData.mock
    private let currentPage = BehaviorSubject<Int>(value: 0)
    private var finishedIntro: Bool = false
    
    private lazy var clvOnboard: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let clv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        clv.delegate = self
        clv.dataSource = self
        clv.register(OnboardingViewCell.self, forCellWithReuseIdentifier: OnboardingViewCell.identifier)
        clv.isPagingEnabled = true
        clv.showsHorizontalScrollIndicator = false
        return clv
    }()
    
    private lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.numberOfPages = self.datas.count
        page.currentPage = 0
        page.currentPageIndicatorTintColor = UIColor(rgb: 0xFF7622)
        page.pageIndicatorTintColor = UIColor(rgb: 0xFFE1CE)
        return page
    }()
    
    private let btnNext: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = Font.bold(14)
        button.backgroundColor = UIColor(rgb: 0xFF7622)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let btnSkip: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor(rgb: 0x646982), for: .normal)
        button.titleLabel?.font = Font.regular(16)
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupConstraints()
        self.binding()
        self.autoScrollPage()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = self.clvOnboard.frame.size
        if let layout = self.clvOnboard.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: size.width, height: size.height)
        }
    }
    
    private func setupConstraints() {
        self.view.addSubview(self.clvOnboard)
        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.btnNext)
        self.view.addSubview(self.btnSkip)
        
        self.clvOnboard.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(55)
            make.right.equalToSuperview()
            make.height.equalTo(self.view.snp.height).multipliedBy(0.6)
        }
        
        self.btnSkip.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-8)
            make.width.equalTo(50)
            make.height.equalTo(24)
            make.centerX.equalTo(self.btnNext.snp.centerX)
        }
        
        self.btnNext.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(62)
            make.bottom.equalTo(self.btnSkip.snp.top).offset(-12)
        }
        
        self.pageControl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.btnNext.snp.top).offset(-60)
        }
    }
    
    private func autoScrollPage() {
        Observable<Int>.interval(.seconds(4), scheduler: MainScheduler.instance)
            .take(self.datas.count - 1)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                let pageIndex = (self.pageControl.currentPage + 1) % self.datas.count
                self.updateUI(atPage: pageIndex)
            })
            .disposed(by: self.bag)
    }
    
    private func binding() {
        self.btnNext.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                var pageIndex = self.pageControl.currentPage
                if pageIndex < self.datas.count - 1 {
                    pageIndex += 1
                    self.currentPage.onNext(pageIndex)
                } else {
                    
                }
            })
            .disposed(by: self.bag)
        
        self.btnSkip.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.currentPage.onNext(self.pageControl.numberOfPages - 1)
            })
            .disposed(by: self.bag)
        
        self.pageControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.updateUI(atPage: self.pageControl.currentPage)
            })
            .disposed(by: self.bag)
        
        self.currentPage
            .subscribe(onNext: { [weak self] pageIndex in
                guard let self else { return }
                self.updateUI(atPage: pageIndex)
            })
            .disposed(by: self.bag)
    }
    
    private func updateUI(atPage pageIndex: Int) {
        if !self.finishedIntro && pageIndex == self.pageControl.numberOfPages {
            self.finishedIntro = true
        }
        
        let offsetX = self.clvOnboard.frame.size.width * CGFloat(pageIndex)
        self.clvOnboard.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
        self.pageControl.currentPage = pageIndex
        if pageIndex == self.datas.count - 1 {
            self.btnNext.setTitle("GET STARTED", for: .normal)
            self.btnSkip.alpha = 0
        }
    }
}

extension OnboardingController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingViewCell.identifier, for: indexPath) as? OnboardingViewCell else {
            return UICollectionViewCell()
        }
        cell.data = datas[indexPath.item]
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        self.currentPage.onNext(index)
    }
}

class OnboardingViewCell: UICollectionViewCell {
    static let identifier = String(describing: OnboardingViewCell.self)
    
    var data: OnboardingData? {
        didSet {
            imgIntro.image = UIImage(named: data?.imageName ?? "")
            lblTitle.text = data?.title
            lblSubtitle.text = data?.subtitle
        }
    }
    
    private let imgIntro: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(rgb: 0x98A8B8)
        return imageView
    }()
    
    private let lblTitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x32343E)
        label.text = "All your favorites"
        label.font = Font.bold(24)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private let lblSubtitle: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x646982)
        label.text = "Get all your loved foods in one once place, you just place the orer we do the rest"
        label.font = Font.regular(16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(self.imgIntro)
        self.contentView.addSubview(self.lblTitle)
        self.contentView.addSubview(self.lblSubtitle)
        
        self.imgIntro.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(68)
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-68)
            make.height.equalTo(self.imgIntro.snp.width).multipliedBy(1.22)
        }
        
        self.lblTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.imgIntro.snp.bottom).offset(44)
            make.right.equalToSuperview().offset(-16)
        }
        
        self.lblSubtitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
    }
}
