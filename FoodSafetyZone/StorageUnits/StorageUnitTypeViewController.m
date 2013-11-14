//
//  StorageUnitTypeViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 20/07/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "StorageUnitTypeViewController.h"
#import "AddStorageUnitTypeViewController.h"
#import "StorageUnitTypeEditViewController.h"

@interface StorageUnitTypeViewController ()

@end

@implementation StorageUnitTypeViewController
@synthesize filteredListContent,listContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,idForList,filteredId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"UNIT TYPE";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"new-add-icon.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    listContent = [[NSMutableArray alloc]init];
    idForList = [[NSMutableArray alloc]init];
    
    dbmanager = [DBManager sharedInstance];
    [self loadDataForPage];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    self.filteredId = [NSMutableArray arrayWithCapacity:[self.idForList count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

-(void)loadDataForPage
{
    if (listContent)
    {
        [listContent removeAllObjects];
        [idForList removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnitType"];
    while([dbmanager.fmResults next])
    {
        
        [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"storageUnitType"]]];
        [idForList addObject:[NSString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]]];
        NSLog(@"minTemp %f",[dbmanager.fmResults doubleForColumn:@"minTemp"]);
        NSLog(@"maxTemp %f",[dbmanager.fmResults doubleForColumn:@"maxTemp"]);
    }

    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [self.filteredListContent count];
    }
	else
	{
        return [self.listContent count];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        cell.textLabel.text = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
        cell.textLabel.text = [self.listContent objectAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(235, 3, 40, 40);
    editButton.tag = indexPath.row;
    [editButton setImage:[UIImage imageNamed:@"edit-icon.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:editButton];
    
    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(275, 3, 40, 40);
    deleteButton.tag = indexPath.row;
    [deleteButton setImage:[UIImage imageNamed:@"delete-icon.png"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(editContent:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:deleteButton];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


-(void)editContent:(UIButton *)sender
{
    if (sender.currentImage == [UIImage imageNamed:@"edit-icon.png"])
    {
        if (self.tableView == self.searchDisplayController.searchResultsTableView)
        {
            dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[filteredId objectAtIndex:sender.tag]];
        }
        else
        {
            dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[idForList objectAtIndex:sender.tag]];
        }
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
        {    // The iOS device = iPhone or iPod Touch
            CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
            
            if (iOSDeviceScreenSize.height == 480)
            {
                StorageUnitTypeEditViewController *storageUnitEdit = [[StorageUnitTypeEditViewController alloc]initWithNibName:@"StorageUnitTypeEditViewController" bundle:nil];
                [self.navigationController pushViewController:storageUnitEdit animated:YES];
            }
            if (iOSDeviceScreenSize.height > 480)
            {
                StorageUnitTypeEditViewController *storageUnitEdit = [[StorageUnitTypeEditViewController alloc]initWithNibName:@"StorageUnitTypeEditViewController5" bundle:nil];
                [self.navigationController pushViewController:storageUnitEdit animated:YES];
            }
        }
    }
    else if (sender.currentImage == [UIImage imageNamed:@"delete-icon.png"])
    {
        NSMutableArray *checkExistance = [[NSMutableArray alloc]init];
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM AddStorageUnits WHERE UnitType = ?",[listContent objectAtIndex:sender.tag]];
        while([dbmanager.fmResults next])
        {
            [checkExistance addObject:[dbmanager.fmResults stringForColumn:@"UnitType"]];
        }
        if ([checkExistance count]>0)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Unit Type in use" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
        }
        else
        {
            NSLog(@"%@",[listContent objectAtIndex:sender.tag]);
            bool bScuees;
            bScuees =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM AddStorageUnitType WHERE storageUnitType = ?",[listContent objectAtIndex:sender.tag]];
            
            if ([dbmanager.fmDatabase hadError])
            {
                NSLog(@"%@",[dbmanager.fmDatabase lastErrorMessage]);
                NSString *alertValue;
                if ([dbmanager.fmDatabase lastErrorCode]==19)
                {
                    alertValue = [NSString stringWithFormat:@"Storage Unit Name already taken!"];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                sucess.tag = 1;
                [sucess show];
            }
            if (bScuees == YES)
            {
                [listContent removeObjectAtIndex:sender.tag];
                [self.tableView reloadData];
            }

        }

    }
}

    

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     //	 */
    for (int i = 0; i<[listContent count];i++)
    {
        NSComparisonResult result = [[listContent objectAtIndex:i] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:[listContent objectAtIndex:i]];
        }
    }
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)viewDidDisappear:(BOOL)animated
{
    // save the state of the search UI so that it can be restored if the view is re-created
//    self.searchWasActive = [self.searchDisplayController isActive];
//    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
//    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
}

-(void)addClicked
{

    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        
        
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        if (iOSDeviceScreenSize.height == 480)
        {
            AddStorageUnitTypeViewController *addUnitTypes = [[AddStorageUnitTypeViewController alloc]initWithNibName:@"AddStorageUnitTypeViewController" bundle:nil];
            [self.navigationController pushViewController:addUnitTypes animated:YES];
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            AddStorageUnitTypeViewController *addUnitTypes = [[AddStorageUnitTypeViewController alloc]initWithNibName:@"AddStorageUnitTypeViewController5" bundle:nil];
            [self.navigationController pushViewController:addUnitTypes animated:YES];
        }
    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
