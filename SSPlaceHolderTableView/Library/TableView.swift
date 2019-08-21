//
//  TableView.swift
//  SSPlaceHolderTableView
//
//  Created by Vishal Patel on 11/01/19.
//  Copyright © 2019 Vishal Patel. All rights reserved.
//

import UIKit

public enum SSPlaceHolderStates {
    case dataAvailable(viewController: UIViewController)
    case noDataAvailable(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?)
    case noDataAvailableWithCustomView(_ customView: UIView?)
    case loading(loadingImg: UIImage?, loadingLabelTitle: NSAttributedString?)
    case loadingWithCustomView(_ customView: UIView?)
    case noDataAvailableWithButton(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?)
    case noDataAvailableWithButtonCustomView(_ customView: UIView?)
    case unknown
}

protocol networkRechabilityProtocol: class {
    func retryNetworkCall()
}
var gCenterOffSetMultiplier: CGFloat = 0.75

public class TableView: UITableView {
    
    var objLoadingView: LoadingView?
    var objNoDataView: NoDataView?
    var objNoDataAvailableWithButtonView: NoDataAvailableWithButtonView?
    var centerOffSetMultiplier: CGFloat? {
        didSet {
            gCenterOffSetMultiplier = centerOffSetMultiplier ?? 0.75
        }
    }
    public var networkUnReachableBlock: (() -> Void)?
    
    override public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setUpTableView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
        setUpTableView()
    }
    
    private func setUpTableView() {
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
        objLoadingView?.loadingTitleText = loadingLabelTitle ?? "Please Wait...".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .lightGray)
        let img = UIImage(named: "loading", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
        objLoadingView?.loadingImg = loadingImg ?? img
        self.backgroundView = objLoadingView
        self.separatorColor = UIColor.clear
        self.dataSource = nil
        self.delegate = nil
    }
    
    private func hideLoadinTableView(controller: UIViewController) {
        self.dataSource = (controller as! UITableViewDataSource)
        self.delegate = (controller as! UITableViewDelegate)
        self.backgroundView = nil
        self.reloadData()
    }
    
    private func showNoDataPlaceHolder(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?, customView: UIView?) {
        if customView != nil {
            self.backgroundView = customView
        } else {
            objNoDataView?.noDataDescriptionText = noDataLabelDescription ?? "".makeAttributedString(font: objNoDataView?.lblNoDataDesc.font ?? UIFont.systemFont(ofSize: 17.0), textColor: .lightGray)
            objNoDataView?.noDataTitleText = noDataLabelTitle ?? "".makeAttributedString(font: objNoDataView?.lblNoDataTitle.font ?? UIFont.systemFont(ofSize: 25.0), textColor: .gray)
            let img = UIImage(named: "noData", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
            objNoDataView?.noDataImg = noDataImg ?? img
            self.backgroundView = objNoDataView
        }
        self.separatorColor = UIColor.clear
        self.dataSource = nil
        self.delegate = nil
    }
    
    private func showNoDataPlaceHolderWithButton(noDataImg: UIImage?, noDataLabelTitle: NSAttributedString?, noDataLabelDescription: NSAttributedString?, customView: UIView?) {
        if(customView != nil){
            self.backgroundView = customView
        }else{
            objNoDataAvailableWithButtonView?.noInternetTitleText = noDataLabelTitle ?? "".makeAttributedString(font: UIFont.systemFont(ofSize: 25), textColor: .gray)
            objNoDataAvailableWithButtonView?.noInternetSubTitleText = noDataLabelDescription ?? "".makeAttributedString(font: objNoDataAvailableWithButtonView?.lblNoInternetSubtitle.font ?? UIFont.systemFont(ofSize: 17.0), textColor: .lightGray)
            let img = UIImage(named: "noInternet", in: Bundle(identifier: "org.cocoapods.SSPlaceHolderTableView"), compatibleWith: nil)
            objNoDataAvailableWithButtonView?.noInternetImg = noDataImg ?? img
            objNoDataAvailableWithButtonView?.btnTryAgain.addTarget(self, action: #selector(retryButtonTapped(sender:)), for: .touchUpInside)
            self.backgroundView = objNoDataAvailableWithButtonView
            self.separatorColor = UIColor.clear
            self.dataSource = nil
            self.delegate = nil
        }
    }
    
    @objc func retryButtonTapped(sender: UIButton) {
        //        networkDelegate?.retryNetworkCall()
        guard let compl = self.networkUnReachableBlock else {
            return
        }
        compl()
    }
}
