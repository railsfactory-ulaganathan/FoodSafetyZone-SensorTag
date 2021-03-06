//
//  ApprovedSuppliersViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 07/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ApprovedSuppliersViewController.h"
#import "AddSuppliersViewController.h"
#import "EditSuppliersViewController.h"

@interface ApprovedSuppliersViewController ()
{
    int searchtag;
}

@end

@implementation ApprovedSuppliersViewController
@synthesize filteredListContent,listContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive,filteredImagesList,ImagesList,search,mainScroll,timerStatus,filteredTimerStatus,allIDS,filteredIDS;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"SUPPLIERS";
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"new-add-icon.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    addButton = nil;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    rightBarButton = nil;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-main-menu-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    [self loadDataForPage];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [search setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    search.showsCancelButton = YES;
    search.tintColor = [UIColor lightGrayColor];
    
    searchWasActive = NO;
    searchtag = 0;
    // Do any additional setup after loading the view from its nib.
}

-(void)loadDataForPage
{
    listContent = [[NSMutableArray alloc]init];
    ImagesList = [[NSMutableArray alloc]init];
    allIDS = [[NSMutableArray alloc]init];
    
    dbmanager = [DBManager sharedInstance];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    self.filteredImagesList = [NSMutableArray arrayWithCapacity:[self.ImagesList count]];
    self.filteredIDS = [NSMutableArray arrayWithCapacity:[self.allIDS count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
    
    if (listContent)
    {
        [listContent removeAllObjects];
        [ImagesList removeAllObjects];
        [allIDS removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM suppliers"];
    while([dbmanager.fmResults next])
    {
        [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"supplierName"]]];
        NSData *tempData = [dbmanager.fmResults dataForColumn:@"supplierImage"];
        [ImagesList addObject:[UIImage imageWithData:tempData]];
        tempData = nil;
        [allIDS addObject:[NSMutableString stringWithFormat:@"%d",[dbmanager.fmResults intForColumn:@"id"]]];
    }
    [self gridViewGeneration:[listContent count] :listContent :ImagesList :timerStatus];
    
}

-(void)gridViewGeneration:(int)count :(NSArray *)list :(NSArray *)imgList :(NSArray *)timer
{
    NSArray *viewsToRemove = [mainScroll subviews];
    for (UIView *v in viewsToRemove) [v removeFromSuperview];
    int xpos,ypos;
    xpos = 5;
    ypos = 10;
    int position = 0;
    for (int i = 0; i<count; i++)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridViewCell" owner:nil options:nil];
        GridViewCell *cell  = [nib objectAtIndex:0];
        cell.imgView.layer.cornerRadius = 8.0;
        cell.imgView.layer.masksToBounds = YES;
        cell.backgroundColor = [UIColor clearColor];
        cell.imgView.layer.borderWidth = 1;
        cell.imgView.layer.borderColor = [[UIColor greenColor] CGColor];
        nib = nil;
        if (i%2==0)
        {
            cell.frame = CGRectMake(xpos, ypos, 150, 150);
            cell.imgView.image = [imgList objectAtIndex:position];
            cell.titleLbl.text = [NSString stringWithFormat:@"%@",[list objectAtIndex:position]];
            cell.titleLbl.backgroundColor = [UIColor whiteColor];
            [mainScroll addSubview:cell];
            xpos += 160;
        }
        else
        {
            cell.frame = CGRectMake(xpos, ypos, 150, 150);
            cell.imgView.image = [imgList objectAtIndex:position];
            cell.titleLbl.text = [NSString stringWithFormat:@"%@",[list objectAtIndex:position]];
            cell.titleLbl.backgroundColor = [UIColor whiteColor];
            [mainScroll addSubview:cell];
            ypos += 160;
            xpos = 10;
        }
        UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTap:)];
        single.accessibilityLabel = [NSString stringWithFormat:@"%d",position];
        single.numberOfTapsRequired = 1;
        [cell addGestureRecognizer:single];
        single = nil;
        [mainScroll addSubview:cell];
        cell = nil;
        position +=1;
    }
    mainScroll.contentSize = CGSizeMake(320, ypos + 200);
}

-(void)singleTap:(UITapGestureRecognizer *)position
{
    if([filteredListContent count]==0)
    {
        dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[allIDS objectAtIndex:[position.accessibilityLabel intValue]]];
    }
    else
    {
        dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[filteredIDS objectAtIndex:[position.accessibilityLabel intValue]]];
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            EditSuppliersViewController *editSuppliers = [[EditSuppliersViewController alloc]initWithNibName:@"EditSuppliersViewController" bundle:nil];
            [self.navigationController pushViewController:editSuppliers animated:YES];
            editSuppliers = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            EditSuppliersViewController *editSuppliers = [[EditSuppliersViewController alloc]initWithNibName:@"EditSuppliersViewController5" bundle:nil];
            [self.navigationController pushViewController:editSuppliers animated:YES];
            editSuppliers = nil;
        }
    }
}

-(void)addClicked
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            AddSuppliersViewController *addSupplers = [[AddSuppliersViewController alloc]initWithNibName:@"AddSuppliersViewController" bundle:nil];
            [self.navigationController pushViewController:addSupplers animated:YES];
            addSupplers = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            AddSuppliersViewController *addSupplers = [[AddSuppliersViewController alloc]initWithNibName:@"AddSuppliersViewController5" bundle:nil];
            [self.navigationController pushViewController:addSupplers animated:YES];
            addSupplers = nil;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredListContent removeAllObjects];
    [self.filteredImagesList removeAllObjects];
    [self.filteredTimerStatus removeAllObjects];// First clear the filtered array.
    for (int i = 0; i<[listContent count];i++)
    {
        NSComparisonResult result = [[listContent objectAtIndex:i] compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame)
        {
            [self.filteredListContent addObject:[listContent objectAtIndex:i]];
            [self.filteredImagesList addObject:[ImagesList objectAtIndex:i]];
            [self.filteredTimerStatus addObject:[timerStatus objectAtIndex:i]];
            searchtag = 1;
        }
    }
    if (searchtag == 0)
    {
        [self gridViewGeneration:[listContent count] :listContent :ImagesList :timerStatus];
    }
    else
    {
        [self gridViewGeneration:[filteredListContent count] :filteredListContent :filteredImagesList :filteredTimerStatus];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([filteredListContent count]==0)
    {
        UIAlertView *searchAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Search not found!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [searchAlert show];
        searchAlert = nil;
    }
}

-(void)clearMemory
{
    listContent = nil;
    ImagesList = nil;
    filteredListContent = nil;
    filteredImagesList = nil;
    savedSearchTerm = nil;
    search = nil;
}

-(void)backClicked
{
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
