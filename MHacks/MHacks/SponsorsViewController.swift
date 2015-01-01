//
//  SponsorsViewController.swift
//  MHacks
//
//  Created by Ben Oztalay on 11/5/14.
//  Copyright (c) 2014 MHacks. All rights reserved.
//

import UIKit

class SponsorsViewController: UIViewController, GridLayoutDelegate, UICollectionViewDataSource {
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let observer = Observer<[Sponsor]> { [unowned self] sponsors in
            self.sponsorOrganizer = SponsorOrganizer(sponsors: sponsors)
        }
        
        self.fetchResultsManager.observerCollection.addObserver(observer)
    }
    
    // MARK: Model
    
    let fetchResultsManager: FetchResultsManager<Sponsor> = {
        
        let query = PFQuery(className: "Sponsor")
        
        query.includeKey("tier")
        query.includeKey("location")
        
        return FetchResultsManager<Sponsor>(query: query)
    }()
    
    private var sponsorOrganizer: SponsorOrganizer = SponsorOrganizer(sponsors: []) {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    // MARK: View
    
    private func fetch() {
        
        if !fetchResultsManager.fetching {
            
            errorLabel.hidden = true
            
            if fetchResultsManager.results.isEmpty {
                loadingIndicatorView.startAnimating()
            }
            
            fetchResultsManager.fetch { error in
                
                self.loadingIndicatorView.stopAnimating()
                
                if error != nil {
                    self.errorLabel.hidden = false
                }
            }
        }
    }
    
    // MARK: View
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var loadingIndicatorView: UIActivityIndicatorView!
    @IBOutlet private var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView!.registerNib(UINib(nibName: "SponsorTierHeader", bundle: nil), forSupplementaryViewOfKind: GridLayout.SupplementaryViewKind.Header.rawValue, withReuseIdentifier: "TierHeader")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let indexPath = collectionView.indexPathsForSelectedItems().first as? NSIndexPath
        
        transitionCoordinator()?.animateAlongsideTransition({ context in
            
            self.collectionView.deselectItemAtIndexPath(indexPath, animated: animated)
            
            }, completion: { context in
                
                if context.isCancelled() {
                    self.collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
                }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetch()
    }
    
    // MARK: Collection view delegate
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "TierHeader", forIndexPath: indexPath) as SponsorTierHeader
        
        headerView.textLabel.text = sponsorOrganizer.tiers[indexPath.section].name
        
        return headerView
    }
    
    // MARK: Collection view data source
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sponsorOrganizer.tiers.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorOrganizer.sponsors[section].count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SponsorCell", forIndexPath: indexPath) as SponsorCell
        
        let sponsor = sponsorOrganizer.sponsors[indexPath.section][indexPath.item]
        
        sponsor.logo.getDataInBackgroundWithBlock { data, error in
            
            if data != nil {
                
                if cell === collectionView.cellForItemAtIndexPath(indexPath) {
                    
                    if let image = UIImage(data: data) {
                        cell.logoView.image = image
                    }
                }
            }
        }
    
        return cell
    }
    
    // MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Show Sponsor" {
            
            let indexPath = collectionView!.indexPathsForSelectedItems().first as NSIndexPath
            
            let viewController = segue.destinationViewController as SponsorViewController
            viewController.sponsor = sponsorOrganizer.sponsors[indexPath.section][indexPath.item]
        }
    }
}
