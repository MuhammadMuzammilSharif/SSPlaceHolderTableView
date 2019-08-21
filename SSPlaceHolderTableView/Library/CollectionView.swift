//
//  CollectionView.swift
//  SSPlaceHolderTableView
//
//  Created by Vishal Patel on 11/01/19.
//  Copyright © 2019 Vishal Patel. All rights reserved.
//

import UIKit

public class CollectionView: UICollectionView {
    
    var objLoadingView: LoadingView?
    var objNoDataView: NoDataView?
    var objNoDataAvailableWithButtonView: NoDataAvailableWithButtonView?
    var onNoDataButtonTouch: (() -> Void)?

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setUpCollectionView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        objLoadingView = LoadingView.instanceFromNib()
        objNoDataView = NoDataView.instanceFromNib()
        objNoDataAvailableWithButtonView = NoDataAvailableWithButtonView.instanceFromNib()
    }
    
    public func setState(_ state: SSPlaceHolderStates) {
        switch state {
        case .dataAvailable(let viewController):
            hideLoadinTableView(controller: viewController)
        case .noDataAvailable(let noDataImg, let noDataLabelTitle, let noDataLabelDescription):
            showNoDataPlaceHolder(noDataImg: noDataImg, noDataLabelTitle: noDataLabelTitle, noDataLabelDescription: noDataLabelDescription, customView: nil)
        case .noDataAvailableWithCustomView(let customView):
            showNoDataPlaceHolder(noDataImg: nil, noDataLabelTitle: nil, noDataLabelDescription: nil, customView: customView)
        case .loading(let img, let title):
            showLoadingTableView(loadingImg: img, loadingLabelTitle: title, customView: nil)
        case .loadingWithCustomView(let customView):
            showLoadingTableView(loadingImg: nil, loadingLabelTitle: nil, customView: customView)
        case .noDataAvailableWithButton(let noDataImg, let noDataLabelTitle, let noDataLabelDescription):
            showNoDataPlaceHolderWithButton(noDataImg: noDataImg, noDataLabelTitle: noDataLabelTitle, noDataLabelDescription: noDataLabelDescription, customView: nil)
        case .noDataAvailableWithButtonCustomView(let customView):
            showNoDataPlaceHolderWithButton(noDataImg: nil, noDataLabelTitle: nil, noDataLabelDescription: nil, customView: customView)
        default: break
            
        }
    }
    
    private func showLoadingTableView(loadingImg: UIImage?, loadingLabelTitle: NSAttributedString?, customView: UIView?) {
        if customView != nil {
            self.backgroundView = customView
        } else {
            objLoadingView?.loadingTitleText = loadingLabelTitle ?? "Please Wait...".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .lightGray)
            let img = UIImage(named: "loading", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
            objLoadingView?.loadingImg = loadingImg ?? img
            self.backgroundView = objLoadingView
        }
        self.dataSource = nil
        self.delegate = nil
    }
    
    private func hideLoadinTableView(controller: UIViewController) {
        self.dataSource = (controller as! UICollectionViewDataSource)
        self.delegate = (controller as! UICollectionViewDelegate)
        self.backgroundView = nil
        self.reloadData()
    }
    
    private func showNoDataPlaceHolder(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?,customView: UIView?) {
        if customView != nil {
            self.backgroundView = customView
        } else {
            objNoDataView?.noDataTitleText = noDataLabelTitle ?? "".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .lightGray)
            objNoDataView?.noDataDescriptionText = noDataLabelDescription ?? "".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .lightGray)
            let img = UIImage(named: "noData", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
            objNoDataView?.noDataImg = noDataImg ?? img
            self.backgroundView = objNoDataView
        }
        self.dataSource = nil
        self.delegate = nil
    }
    
    private func showNoDataPlaceHolderWithButton(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?, customView: UIView?) {
        if customView != nil {
            self.backgroundView = customView
        } else {
            objNoDataAvailableWithButtonView?.noInternetTitleText = noDataLabelTitle ?? "".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .gray)
            objNoDataAvailableWithButtonView?.noInternetSubTitleText = noDataLabelDescription ?? "".makeAttributedString(font: objNoDataAvailableWithButtonView?.lblNoInternetSubtitle.font ?? UIFont.systemFont(ofSize: 17.0), textColor: .lightGray)
            let img = UIImage(named: "noInternet", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
            objNoDataAvailableWithButtonView?.noInternetImg = noDataImg ?? img
            
            objNoDataAvailableWithButtonView?.btnTryAgain.addTarget(self, action: #selector(retryButtonTapped(sender:)),   for: .touchUpInside)
            self.backgroundView = objNoDataAvailableWithButtonView
        }
        self.dataSource = nil
        self.delegate = nil
    }

    @objc func retryButtonTapped(sender: UIButton) {
        guard let compl = self.onNoDataButtonTouch else {
            return
        }
        compl()
    }
    
}

extension String {
    func makeAttributedString(font: UIFont, textColor: UIColor) -> NSAttributedString {
        let attriString = NSAttributedString(string:self, attributes:
            [NSAttributedString.Key.foregroundColor: textColor,
             NSAttributedString.Key.font: font])
        return attriString
    }
}
