//
//  GRCategoryListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 09/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "GRCategoryListViewController.h"

@interface GRCategoryListViewController ()
{
    int searchtag;
    NSMutableString *tempStorageValues;
}

@end

@implementation GRCategoryListViewController
@synthesize mainScroll,listContent,ImagesList,filteredImagesList,filteredListContent,savedSearchTerm,searchWasActive,savedScopeButtonIndex,search,supplierNameLbl;
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
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"search.png"]forState:UIControlStateNormal];
    self.navigationItem.title = @"GOODS RECEIVED";
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
    tempStorageValues = [[NSMutableString alloc]init];
    
    dbmanager = [DBManager sharedInstance];
    self.filteredListContent = [NSMutableArray arrayWithCapacity:[self.listContent count]];
    self.filteredImagesList = [NSMutableArray arrayWithCapacity:[self.ImagesList count]];
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        self.savedSearchTerm = nil;
    }

    NSMutableArray *temp = [[NSMutableArray alloc]init];
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM temp WHERE id = 1"];
    while([dbmanager.fmResults next])
    {
        tempStorageValues = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"tempStorageValue"]];
    }
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM suppliers WHERE id = ?",[NSNumber numberWithInt:[tempStorageValues intValue]]];
    while([dbmanager.fmResults next])
    {
        supplierNameLbl.text = [NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"supplierName"] ];
    }
    if (listContent)
    {
        [listContent removeAllObjects];
        [ImagesList removeAllObjects];
    }
    if (temp)
    {
        [temp removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT foodCategory FROM supplierFoodItems WHERE supplierId = ?",[NSNumber numberWithInt:[tempStorageValues intValue]]];
    while([dbmanager.fmResults next])
    {
        if (![temp containsObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodCategory"]]])
            [temp addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodCategory"]]];
    }
    
    for (int i = 0; i < [temp count]; i++)
    {
        dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM foodCategory WHERE foodCategoryName = ?",[temp objectAtIndex:i]];
        while([dbmanager.fmResults next])
        {
            [listContent addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"foodCategoryName"]]];
            NSData *tempData = [dbmanager.fmResults dataForColumn:@"foodCategoryImage"];
            [ImagesList addObject:[UIImage imageWithData:tempData]];
            tempData = nil;
        }
    }
    temp = nil;
    [self gridViewGeneration:[listContent count] :listContent :ImagesList];
}

-(void)gridViewGeneration:(int)count :(NSArray *)list :(NSArray *)imgList
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
    BOOL status;
    if([filteredListContent count]==0)
    {
        status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE temp SET tempArray = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%@,%@",supplierNameLbl.text,[listContent objectAtIndex:[sender.accessibilityLabel integerValue]]]];
    }
    else
    {
       status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%@,%@",supplierNameLbl.text,[filteredListContent objectAtIndex:[sender.accessibilityLabel integerValue]]]];
    }
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        
        [self clearMemory];
        if (iOSDeviceScreenSize.height == 480)
        {
            GRFoodItemListViewController *foodItemList = [[GRFoodItemListViewController alloc]initWithNibName:@"GRFoodItemListViewController" bundle:nil];
            [self.navigationController pushViewController:foodItemList animated:YES];
            foodItemList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            GRFoodItemListViewController *foodItemList = [[GRFoodItemListViewController alloc]initWithNibName:@"GRFoodItemListViewController5" bundle:nil];
            [self.navigationController pushViewController:foodItemList animated:YES];
            foodItemList = nil;
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.filteredListContent removeAllObjects];
    [self.filteredImagesList removeAllObjects];
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
        [self gridViewGeneration:[listContent count] :listContent :ImagesList];
    }
    else
    {
        [self gridViewGeneration:[filteredListContent count] :filteredListContent :filteredImagesList];
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
    dbmanager = nil;
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
