//
//  ECListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 21/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "ECListViewController.h"
#import "ECDisplayReportViewController.h"

@interface ECListViewController ()

@end

@implementation ECListViewController
@synthesize TLFooterView,TLHeaderView;

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
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(0, 0, 50, 40);
    [doneButton setImage:[UIImage imageNamed:@"mail-icon.png"] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:doneButton];
    doneButton = nil;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    rightBarButton = nil;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    back.frame = CGRectMake(0, 0, 50, 40);
    [back setImage:[UIImage imageNamed:@"new-back-button.png"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:back];
    back = nil;
    self.navigationItem.leftBarButtonItem = leftBarButton;
    leftBarButton = nil;
    self.navigationItem.title = @"EQUIPMENT CALIBRATION";
    [self loadDataForPage];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)loadDataForPage
{
    dbmanager = [DBManager sharedInstance];
    viewTags = 0;
    listOfDates = [[NSMutableArray alloc]init];
    listOfRecords = [[NSMutableArray alloc]init];
    rowwise = [[NSMutableArray alloc]init];
    
    if (listOfDates)
    {
        [listOfDates removeAllObjects];
        [listOfRecords removeAllObjects];
    }
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM RecordsForEquipments WHERE dateOfService BETWEEN ? AND ? ",[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:0]],[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:1]]];
    while([dbmanager.fmResults next])
    {
        [listOfDates addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"dateOfService"]]];
    }
    //SORTING ALL THE VALUES
    [listOfDates sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *newArray =  [[NSSet setWithArray:listOfDates] allObjects];
    
    //FINDING NUMBER OF OCCURANCES
    int occurrences = 0;
    for (int i=0; i<[newArray count]; i++)
    {
        for(NSString *string in listOfDates){
            occurrences += ([string isEqualToString:[NSString stringWithFormat:@"%@",[newArray objectAtIndex:i]]]?1:0);
        }
        [listOfRecords addObject:[NSString stringWithFormat:@"%d",occurrences]];
        occurrences = 0;
    }
    [listOfDates removeAllObjects];
    listOfDates = [NSMutableArray arrayWithArray:newArray];
    newArray = nil;
    [self.tableView reloadData];
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
    return [listOfDates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[listOfDates objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, 30, 30);
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:@"count-bg.png"] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%@",[listOfRecords objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell.accessoryView = button;
    button = nil;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL status = [dbmanager.fmDatabase  executeUpdate:@"UPDATE temp SET tempStorageValue = ? WHERE id = 1",[NSMutableString stringWithFormat:@"%@",[listOfDates objectAtIndex:indexPath.row]]];
    if (status == YES)
    {
        NSLog(@"%c",status);
    }
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            ECDisplayReportViewController *reportsList = [[ECDisplayReportViewController alloc]initWithNibName:@"ECDisplayReportViewController" bundle:nil];
            [self.navigationController pushViewController:reportsList animated:YES];
            reportsList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            ECDisplayReportViewController *reportsList = [[ECDisplayReportViewController alloc]initWithNibName:@"ECDisplayReportViewController5" bundle:nil];
            [self.navigationController pushViewController:reportsList animated:YES];
            reportsList = nil;
        }
    }
    
}

-(void)doneClicked
{
    [self seperateDataDaywise];
    if ([listOfDates count]>0)
    {
        [self loadDataForPDF];
    }
    else
    {
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                              message:@"No Record Found!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [myAlertView show];
        myAlertView = nil;
    }
}

-(void)seperateDataDaywise
{
    allViews = [[NSMutableArray alloc]init];
    if (rowwise)
    {
        [rowwise removeAllObjects];
    }
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM RecordsForEquipments WHERE dateOfService BETWEEN ? AND ? ",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
    while([dbmanager.fmResults next])
        
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        NSString *sample = [dbmanager.fmResults stringForColumn:@"dateOfService"];
        NSArray *ttt = [sample componentsSeparatedByString:@","];
        sample = [ttt objectAtIndex:0];
        [dict setValue:[NSString stringWithFormat:@"%@",sample] forKey:@"dateOfService"];
        sample = nil;
        ttt = nil;
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"equipmentName"]] forKey:@"equipmentName"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"contractorName"]] forKey:@"contractorName"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"passStatus"]] forKey:@"passStatus"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"iceWaterTemp"]] forKey:@"iceWaterTemp"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"hotWaterTemp"]] forKey:@"hotWaterTemp"];
        
        if ([dbmanager.fmResults stringForColumn:@"correctiveActions"])
        {
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"correctiveActions"]] forKey:@"correctiveActions"];
        }
        else
        {
            [dict setValue:[NSString stringWithFormat:@" "] forKey:@"correctiveActions"];
        }
        [rowwise addObject:dict];
        dict = nil;
    }
}

-(void)loadDataForPDF
{
    totalColumns = 8;
    xpos = 10;
    ypos = 0;
    cellWidth = 76;
    cellHeight = 30;
    
    GeneratePDF = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 792, 612)];
    
    [self generateView];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Enter file name"
                                                          message:@"sdfsdfsdfdsffsf" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    myAlertView.tag = 22;
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    [myAlertView addSubview:myTextField];
    [myAlertView show];
    myAlertView = nil;
}

-(void)generateView
{
    if (allViews)
    {
        [allViews removeAllObjects];
    }
    ypos = 20;
    TLHeaderView.frame = CGRectMake(20, ypos, 600, 20);
    [GeneratePDF addSubview:TLHeaderView];
    TLFooterView.frame = CGRectMake(645, ypos, 125, 446);
    [GeneratePDF addSubview:TLFooterView];
    ypos = 50;
    UIView *hdr = [self tableHeaderView];
    [GeneratePDF addSubview:hdr];
    hdr = nil;
    ypos += 75;
    for (int i = 0; i<[rowwise count]; i++)
    {
        if (ypos < 575)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ECTableRow" owner:nil options:nil];
            ECTableRow *rView  = [nib objectAtIndex:0];
            nib = nil;
            rView.frame=CGRectMake(20,ypos,600,50);
            rView.equipmentName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"equipmentName"]];
            rView.contractorName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"contractorName"]];
            rView.dateOfService.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"dateOfService"]];
            rView.passStatus.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"passStatus"]];
            rView.iceWaterTemp.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"iceWaterTemp"]];
            rView.boilingWaterTemp.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"hotWaterTemp"]];
            rView.correctiveAction.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"correctiveActions"]];
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=49;
        }
        else
        {
            UILabel *pgNumber = [[UILabel alloc]initWithFrame:CGRectMake(700, 590, 80,20)];
            pgNumber.text = [NSString stringWithFormat:@"Page %d",[allViews count]+1];
            [GeneratePDF addSubview:pgNumber];
            pgNumber = nil;
            [allViews addObject:GeneratePDF];
            GeneratePDF = nil;
            ypos = 20;
            [self generatePdfView];
            UIView *hdr = [self tableHeaderView];
            [GeneratePDF addSubview:hdr];
            hdr = nil;
            ypos += 75;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ECTableRow" owner:nil options:nil];
            ECTableRow *rView  = [nib objectAtIndex:0];
            nib = nil;
            rView.frame=CGRectMake(20,ypos,600,50);
            rView.equipmentName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"equipmentName"]];
            rView.contractorName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"contractorName"]];
            rView.dateOfService.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"dateOfService"]];
            rView.passStatus.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"passStatus"]];
            rView.iceWaterTemp.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"iceWaterTemp"]];
            rView.boilingWaterTemp.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"hotWaterTemp"]];
            rView.correctiveAction.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"correctiveActions"]];
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=49;
        }
    }
    if (ypos <= 590)
    {
        UILabel *pgNumber = [[UILabel alloc]initWithFrame:CGRectMake(700, 590, 80,20)];
        pgNumber.text = [NSString stringWithFormat:@"Page %d",[allViews count]+1];
        [GeneratePDF addSubview:pgNumber];
        pgNumber = nil;
        [allViews addObject:GeneratePDF];
        GeneratePDF = nil;
    }
    [rowwise removeAllObjects];
}
-(void)generatePdfView
{
    viewTags+=1;
    UIView *pdfView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 792, 612)];
    pdfView.tag = viewTags;
    GeneratePDF = pdfView;
    pdfView = nil;
}

-(UIView *)tableHeaderView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ECTableHeader" owner:nil options:nil];
    ECTableHeader *hView  = [nib objectAtIndex:0];
    nib = nil;
    hView.frame=CGRectMake(20,ypos,600,75);
    return hView;
    hView = nil;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = [NSString stringWithFormat:@"%@.pdf",myTextField.text];
    if (actionSheet.tag == 22 && buttonIndex == 1)
    {
        [self createPDFfromUIView:GeneratePDF saveToDocumentsWithFileName:name];
        name = nil;
    }
}

-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    int numberofPages;
    
    NSString *docDirectory =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *pdfPath = [docDirectory stringByAppendingPathComponent:aFilename];
    docDirectory = nil;
    
    // set the size of the page (the page is in landscape format)
    CGRect pageBounds = CGRectMake(0.0f, 0.0f, 792.0f, 612.0f);
    numberofPages = [allViews count];
    
    UIView *tempView = [[UIView alloc]init];
    // create and save the pdf file
    UIGraphicsBeginPDFContextToFile(pdfPath, pageBounds, nil);
    {
        for (int i = 0; i<numberofPages; i++)
        {
            tempView = [allViews objectAtIndex:i];
            UIGraphicsBeginPDFPage();
            [tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
        }
    }
    tempView = nil;
    allViews = nil;
    UIGraphicsEndPDFContext();
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"Reports Record4 from the date %@ to %@",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]]];
        
        NSString *pdfName = [NSString stringWithFormat:@"%@", pdfPath];
        NSData *pdfData = [NSData dataWithContentsOfFile:pdfName];
        pdfName = nil;
        pdfPath = nil;
        [mailer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:aFilename];
        aFilename = nil;
        pdfData = nil;
        [self presentViewController:mailer animated:YES completion:Nil];
        self.navigationController.navigationBar.tintColor = [UIColor greenColor];
        mailer = nil;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Go to iPhone Settings and sync a mail id to receive reports!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
        [self removeSubviews];
        alert = nil;
    }
    myTextField = nil;
}

-(void)removeSubviews
{
    for (int i=0; i<[allViews count]; i++)
    {
        for (UIView *subview in [[allViews objectAtIndex:i] subviews])
        {
            [subview removeFromSuperview];
        }
    }
    allViews = nil;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    NSString *errorStr;
	switch (result)
	{
		case MFMailComposeResultCancelled:
			errorStr = @"Mail cancelled: you cancelled the operation and no email message was queued";
			break;
		case MFMailComposeResultSaved:
			errorStr = @"Mail saved: you saved the email message in the Drafts folder";
			break;
		case MFMailComposeResultSent:
			errorStr = @"Mail sent successfully!!";
			break;
		case MFMailComposeResultFailed:
			errorStr = @"Mail failed: the email message was not saved or queued, possibly due to an error";
			break;
		default:
			errorStr = @"Mail not sent";
			break;
	}
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:errorStr
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
    [self removeSubviews];
    alert = nil;
    errorStr = nil;
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)backClicked
{
    [self clearMemory];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)clearMemory
{
    listOfDates = nil;
    listOfRecords = nil;
    rowwise = nil;
    allViews = nil;
    GeneratePDF = nil;
}

- (void)viewDidUnload
{
    [self setTLHeaderView:nil];
    [self setTLFooterView:nil];
    [super viewDidUnload];
}
@end
