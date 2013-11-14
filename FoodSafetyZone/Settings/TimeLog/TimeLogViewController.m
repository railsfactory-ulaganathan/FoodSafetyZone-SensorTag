//
//  TimeLogViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 20/08/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "TimeLogViewController.h"

@interface TimeLogViewController ()
{
    int viewStatus;
}

@end

@implementation TimeLogViewController
@synthesize filteredListContent,listContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,idForList,filteredId;
@synthesize addPurposeView,addPurposeHeaderLbl,addPurposeTextField,addPurposeDoneButton;
@synthesize editPurposeView,editPurposeHeaderLbl,editPurposeTextField,editPurposeDoneButton,editPurposeDeleteButton,overlayView;

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
    self.navigationItem.title = @"ACTIVITY TIMELOG";
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
    viewStatus = 0;
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
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM Purpose"];
    while([dbmanager.fmResults next])
    {
        
        [idForList addObject:[NSString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]]];
        [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"purposeName"]]];
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
    if (cell == nil)
    {
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
    
    UIImageView *backView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cellbackview.png"]];
    cell.backgroundView = backView;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (viewStatus == 0)
    {
        overlayView.frame = CGRectMake(0, 0, 320, 600);
        [self.view addSubview:overlayView];
        editPurposeView.frame = CGRectMake(20, self.view.center.y - 135, 285, 140);
        editPurposeView.layer.cornerRadius = 5.0;
        [self.view addSubview:editPurposeView];
        [editPurposeTextField becomeFirstResponder];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationController.navigationBarHidden = YES;
        tableView.scrollEnabled = NO;
        editPurposeTextField.text = [listContent objectAtIndex:indexPath.row];
        selectedPurpose = [NSString stringWithFormat:@"%@",[listContent objectAtIndex:indexPath.row]];
    }
    [self openingAnimation];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	[self.filteredListContent removeAllObjects];
	
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
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}

-(void)addClicked
{
    if (viewStatus == 0)
    {
        overlayView.frame = CGRectMake(0, 0, 320, 600);
        [self.view addSubview:overlayView];
        if ([overlayView.subviews count]==0)
        {
            addPurposeView.frame = CGRectMake(20, self.view.center.y - 125, 285, 140);
            addPurposeView.layer.cornerRadius = 5.0;
            [self.view addSubview:addPurposeView];
            [addPurposeTextField becomeFirstResponder];
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        [self openingAnimation];
    }
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addPurposeDoneCicked:(UIButton *)sender
{
    BOOL status;
    if ([addPurposeTextField.text length]>0)
    {
        status = [dbmanager.fmDatabase  executeUpdate:@"INSERT INTO Purpose(id,purposeName) VALUES(NULL,?)",addPurposeTextField.text,nil];
        if (status == YES)
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Activity created" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
            [self loadDataForPage];
        }
        else
        {
            if ([dbmanager.fmDatabase hadError])
            {
                NSString *alertValue;
                if ([dbmanager.fmDatabase lastErrorCode] == 19)
                {
                    alertValue = @"Activity Name already taken !!!";
                }
                else
                {
                    alertValue = [NSString stringWithFormat:@"%@",[dbmanager.fmDatabase lastErrorMessage]];
                }
                UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:alertValue delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [sucess show];
                sucess = nil;
            }
        }
    }
    else
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Activity name can't be empty!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
    }
    if (addPurposeView)
    {
        [addPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    addPurposeTextField.text = @"";
    [self closingAnimation];
}
- (IBAction)editPurposeDoneClicked:(UIButton *)sender
{
    BOOL status;
    status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE Purpose SET purposeName = ? WHERE purposeName = ?",editPurposeTextField.text,selectedPurpose];
    
    if (status == YES)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Activity edited!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        sucess = nil;
        [self loadDataForPage];
    }
    else
    {
        if ([dbmanager.fmDatabase hadError])
        {
            UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbmanager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [sucess show];
            sucess = nil;
        }
    }

    if (editPurposeView)
    {
        [editPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    [self closingAnimation];
}

- (IBAction)editPurposeDeleteClicked:(UIButton *)sender
{
    UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Are you sure to delete the activity?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    sucess.tag = 1;
    [sucess show];
    
    if (editPurposeView)
    {
        [editPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    [self closingAnimation];
}

-(void)dataDelete
{
    bool bScuees;
    bScuees =[dbmanager.fmDatabase executeUpdate:@"DELETE FROM Purpose WHERE purposeName = ?",selectedPurpose];
    
    if ([dbmanager.fmDatabase hadError])
    {
        
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:[dbmanager.fmDatabase lastErrorMessage] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
    }
    if (bScuees == YES)
    {
        UIAlertView *sucess = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Activity deleted!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [sucess show];
        [self loadDataForPage];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((alertView.tag == 1)&&(buttonIndex == 0))
    {
        [self dataDelete];
    }
}

- (void)tapOnViewClicked:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    if (editPurposeView)
    {
        [editPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    if (addPurposeView)
    {
        [addPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
}
- (IBAction)CloseClicked:(id)sender
{
    if (addPurposeView)
    {
        [addPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    if (editPurposeView)
    {
        [editPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    [self closingAnimation];
}

-(void)closingAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.scrollEnabled = YES;
    viewStatus = 0;
    [UIView commitAnimations];
}

-(void)openingAnimation
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationController.navigationBarHidden = YES;
    self.tableView.scrollEnabled = NO;
    viewStatus = 1;
    [UIView commitAnimations];
}

- (IBAction)overlayViewTapped:(id)sender
{
    if (addPurposeView)
    {
        [addPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    if (editPurposeView)
    {
        [editPurposeView removeFromSuperview];
        if (overlayView)
        {
            [overlayView removeFromSuperview];
        }
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tableView.scrollEnabled = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
