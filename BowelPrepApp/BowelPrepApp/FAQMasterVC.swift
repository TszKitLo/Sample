//
//  FAQMasterVC.swift
//  BowelPrepApp
//
//  Created by Guangsha Mou on 3/21/16.
//  Copyright © 2016 UCDMC Bowel Prep. All rights reserved.
//

import UIKit

class FAQMasterVC: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, UIPopoverPresentationControllerDelegate {

    var detailViewController: FAQDetailVC? = nil //
    var faqs = FAQ.getAllFAQs()
    var filteredFAQ = [FAQModel]()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.removeShadow()

        // use card.xib for custom cells
        let nib = UINib(nibName: "Card", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "customCardCell")
        
        // hide extra empty cells
        tableView.tableFooterView = UIView()
        
        // search bar set up
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        searchController.searchBar.scopeButtonTitles = ["All".localized(),
            "Bowel Prep".localized(), "Instruction".localized(), "Miscellaneous".localized()]
        searchController.searchBar.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredFAQ.count
        } else {
            return faqs.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCardCell", forIndexPath: indexPath) as! Card

        var faq: FAQModel
        if searchController.active && searchController.searchBar.text != "" {
            faq = filteredFAQ[indexPath.row]
        } else {
            faq = faqs[indexPath.row]
        }
        
        cell.label.text = faq.question.localized()

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showFAQDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //segue for the popover configuration window
        if segue.identifier == "showFAQDetail" {
            let controller = segue.destinationViewController as! FAQDetailVC
            let faq: FAQModel
            if searchController.active && searchController.searchBar.text != "" {
                faq = filteredFAQ[tableView.indexPathForSelectedRow!.row]
            } else {
                faq = faqs[tableView.indexPathForSelectedRow!.row]
            }
            controller.detailFAQ = faq
        }
    }
    
    // MARK: search bar
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredFAQ = faqs.filter { faq in
            let categoryMatch = (scope == "All") || (faq.category == scope)
            return  categoryMatch && faq.question.localized().lowercaseString.containsString(searchText.lowercaseString)
        }
        
        tableView.reloadData()
    }
    // search bar result updating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
    }
    
    //search bar delegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }

}
