//
//  FormViewController.swift
//  Formulary
//
//  Created by Fabian Canas on 1/16/15.
//  Copyright (c) 2015 Fabian Canas. All rights reserved.
//

import UIKit

public class FormViewController: UIViewController, UITableViewDelegate {
    
    var dataSource: FormDataSource?
    
    public var form :Form! {
        didSet {
            if form != nil {
                dataSource = FormDataSource(form: form, tableView: tableView)
                tableView?.dataSource = dataSource
            } else {
                tableView?.dataSource = nil
            }
        }
    }
    var tableView: UITableView!
    var tableViewStyle: UITableViewStyle = .Grouped
    
    init(form: Form) {
        self.form = form
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func link(form: Form, table: UITableView) {
        dataSource = FormDataSource(form: form, tableView: tableView)
        tableView.dataSource = dataSource
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if tableView == nil {
            tableView = UITableView(frame: view.bounds, style: tableViewStyle)
            tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        }
        if tableView.superview == nil {
            view.addSubview(tableView)
        }
        
        tableView.registerFormCellClasses()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = 60
        tableView.delegate = self
        
        if form != nil {
            dataSource = FormDataSource(form: form, tableView: tableView)
            tableView.dataSource = dataSource
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        tableView.firstResponder()?.resignFirstResponder()
    }
}

extension UIView {
    func firstResponder() -> UIView? {
        if isFirstResponder() {
            return self
        }
        for subview in (subviews as [UIView]) {
            if let responder = subview.firstResponder() {
                return responder
            }
        }
        return nil
    }
}
