//
//  CSListViewController.m
//  FoodSafetyZone
//
//  Created by railsfactory on 22/10/13.
//  Copyright (c) 2013 railsfactory. All rights reserved.
//

#import "CSReportListViewController.h"
#import "CSDisplayReportListViewController.h"

@interface CSReportListViewController ()

@end

@implementation CSReportListViewController
@synthesize TLHeaderView;

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
    self.navigationItem.title = @"CLEANING SCHEDULE";
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
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordForCleaningSchedule WHERE date BETWEEN ? AND ? ",[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:0]],[NSString stringWithFormat:@"%@",[dbmanager.tempArray objectAtIndex:1]]];
    while([dbmanager.fmResults next])
    {
        [listOfDates addObject:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"equipmentName"]]];
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
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
    {    // The iOS device = iPhone or iPod Touch
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if (iOSDeviceScreenSize.height == 480)
        {
            CSDisplayReportListViewController *reportsList = [[CSDisplayReportListViewController alloc]initWithNibName:@"CSDisplayReportListViewController" bundle:nil];
            [self.navigationController pushViewController:reportsList animated:YES];
            reportsList = nil;
        }
        if (iOSDeviceScreenSize.height > 480)
        {
            CSDisplayReportListViewController *reportsList = [[CSDisplayReportListViewController alloc]initWithNibName:@"CSDisplayReportListViewController5" bundle:nil];
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
    
    dbmanager.fmResults=[dbmanager.fmDatabase executeQuery:@"SELECT * FROM recordForCleaningSchedule WHERE date BETWEEN ? AND ? ",[dbmanager.tempArray objectAtIndex:0],[dbmanager.tempArray objectAtIndex:1]];
    while([dbmanager.fmResults next])
        
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        if ([[dbmanager.fmResults stringForColumn:@"frequency"] isEqualToString:@"Daily"])
        {
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"frequencyComments"]] forKey:@"dailyFreq"];
        }
        else
        {
            [dict setValue:[NSString stringWithFormat:@" "] forKey:@"dailyFreq"];
        }
        if ([[dbmanager.fmResults stringForColumn:@"frequency"] isEqualToString:@"Weekly"])
        {
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"frequencyComments"]] forKey:@"weeklyFreq"];
        }
        else
        {
            [dict setValue:[NSString stringWithFormat:@" "] forKey:@"weeklyFreq"];
        }
        if ([[dbmanager.fmResults stringForColumn:@"frequency"] isEqualToString:@"Weekly"])
        {
            [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"frequencyComments"]] forKey:@"monthlyFreq"];
        }
        else
        {
            [dict setValue:[NSString stringWithFormat:@" "] forKey:@"monthlyFreq"];
        }
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"equipmentName"]] forKey:@"equipmentName"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"cleaningInstruction"]] forKey:@"cleaningInstruction"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"productsToUse"]] forKey:@"productsToUse"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"responsiblePerson"]] forKey:@"responsiblePerson"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"reviewedBy"]] forKey:@"reviewedBy"];
        [dict setValue:[NSString stringWithFormat:@"%@",[dbmanager.fmResults stringForColumn:@"specialInstruction"]] forKey:@"specialInstruction"];
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
    TLHeaderView.frame = CGRectMake(20, ypos, 700, 20);
    [GeneratePDF addSubview:TLHeaderView];
    ypos = 50;
    UIView *hdr = [self tableHeaderView];
    [GeneratePDF addSubview:hdr];
    hdr = nil;
    ypos += 60;
    for (int i = 0; i<[rowwise count]; i++)
    {
        if (ypos < 575)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSTableRow" owner:nil options:nil];
            CSTableRow *rView  = [nib objectAtIndex:0];
            nib = nil;
            rView.frame = CGRectMake(20,ypos,700,60);
            rView.equipmentName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"equipmentName"]];
            rView.dailyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"dailyFreq"]];
            rView.weeklyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"weeklyFreq"]];
            rView.monthlyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"monthlyFreq"]];
            rView.cleaningInstr.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"cleaningInstruction"]];
            rView.productsToUse.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"productsToUse"]];
            rView.responsiblePerson.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"responsiblePerson"]];
            rView.reviewedBy.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"reviewedBy"]];
            rView.specialInstr.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"specialInstruction"]];
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=59;
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
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSTableRow" owner:nil options:nil];
            CSTableRow *rView  = [nib objectAtIndex:0];
            nib = nil;
            rView.frame=CGRectMake(20,ypos,700,60);
            rView.equipmentName.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"equipmentName"]];
            rView.dailyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"dailyFreq"]];
            rView.weeklyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"weeklyFreq"]];
            rView.monthlyFreq.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"monthlyFreq"]];
            rView.cleaningInstr.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"cleaningInstruction"]];
            rView.productsToUse.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"productsToUse"]];
            rView.responsiblePerson.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"responsiblePerson"]];
            rView.reviewedBy.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"reviewedBy"]];
            rView.specialInstr.text = [NSString stringWithFormat:@"%@",[[rowwise objectAtIndex:i] objectForKey:@"specialInstruction"]];
            [GeneratePDF addSubview:rView];
            rView = nil;
            ypos+=59;
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
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CSTableHeader" owner:nil options:nil];
    CSTableHeader *hView  = [nib objectAtIndex:0];
    nib = nil;
    hView.frame=CGRectMake(20,ypos,700,60);
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
    [super viewDidUnload];
}
@end
