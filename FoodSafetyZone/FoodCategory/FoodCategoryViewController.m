//
//  FoodCategoryViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 05/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "FoodCategoryViewController.h"

@interface FoodCategoryViewController ()
{
    int searchtag;
}
@end

@implementation FoodCategoryViewController
@synthesize mainScroll,listContent,ImagesList,filteredImagesList,filteredListContent,filteredTimerStatus,savedSearchTerm,timerStatus,searchWasActive,savedScopeButtonIndex,search;

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
    self.navigationItem.title = @"FOOD CATEGORY";
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
    timerStatus = [[NSMutableArray alloc]init];
    
    dbmanager = [DBManager sharedInstance];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    self.filteredImagesList = [NSMutableArray arrayWithCapacity:[self.ImagesList count]];
    self.filteredTimerStatus = [NSMutableArray arrayWithCapacity:[self.timerStatus count]];
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
        [timerStatus removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM foodCategory"];
    while([dbmanager.fmResults next])
    {
        [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodCategoryName"]]];
        
        NSData *tempData = [dbmanager.fmResults dataForColumn:@"foodCategoryImage"];
        [ImagesList addObject:[UIImage imageWithData:tempData]];
        tempData = nil;
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

-(void)singleTap:(UITapGestureRecognizer *)sender
{
    if([filteredListContent count]==0)
    {
        dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[listContent objectAtIndex:[sender.accessibilityLabel intValue]]];
    }
    else
    {
        dbmanager.tempStorageValues = [NSMutableString stringWithFormat:@"%@",[filteredListContent objectAtIndex:[sender.accessibilityLabel intValue]]];
        //searchtag = 0;
    }
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            EditFoodCategoryViewController *editfoodcategory = [[EditFoodCategoryViewController alloc]initWithNibName:@"EditFoodCategoryViewController" bundle:nil];
            [self.navigationController pushViewController:editfoodcategory animated:YES];
            editfoodcategory = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            EditFoodCategoryViewController *editfoodcategory = [[EditFoodCategoryViewController alloc]initWithNibName:@"EditFoodCategoryViewController5" bundle:nil];
            [self.navigationController pushViewController:editfoodcategory animated:YES];
            editfoodcategory = nil;
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
            AddFoodCategoryViewController *addfoodcategory = [[AddFoodCategoryViewController alloc]initWithNibName:@"AddFoodCategoryViewController" bundle:nil];
            [self.navigationController pushViewController:addfoodcategory animated:YES];
            addfoodcategory = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            AddFoodCategoryViewController *addfoodcategory = [[AddFoodCategoryViewController alloc]initWithNibName:@"AddFoodCategoryViewController5" bundle:nil];
            [self.navigationController pushViewController:addfoodcategory animated:YES];
            addfoodcategory = nil;
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
