//
//  QPViewreportController.m
//  Que Pics
//
//  Created by Zoccer Capitan 1 on 11/01/16.
//  Copyright © 2016 AppZoc. All rights reserved.
//

#import "QPViewreportController.h"
#import "QPGlobal.h"
#import "UINavigationController+QPCustomizing.h"
#import "UserSettingsController.h"
#import "QPpurchasepointsController.h"
#import "QPViewProfileController.h"
#import "completeReportCell.h"
#import "QPCommonClass.h"
#import "UIImageView+WebCache.h"

@interface QPViewreportController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSString *dateString;

@end

@implementation QPViewreportController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_profileImageView setClipsToBounds:YES];
    [self initialisation];
    [self customization];
    [self addConstraints];
    self.title = @"View Report";
    [self navigationBarTitle];
    [self showLoadingMode];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.profileImageView sd_setImageWithURL:[NSURL URLWithString:[[QPCommonClass initializeUserDefaults]valueForKey:@"QuestionerImageToViewReport"]]];
        if ([NSData dataWithContentsOfURL:[NSURL URLWithString:[[QPCommonClass initializeUserDefaults]valueForKey:@"UserPhoto"]]] == nil) {
            self.profileImageView.image = [UIImage imageNamed:@"logo"];
        }
    });
    
    
  //  NSLog(@"Question in view report %@",[self.questionArray valueForKey:@"question"]);
    self.questionLabel.text = self.questionString;
//    self.tagElement.text = [NSString stringWithFormat:@"#%@",[self.viewReportArray valueForKey:@"tags"]];
//    NSString *totalNumbers = [NSString stringWithFormat:@"%@",[self.viewReportArray valueForKey:@"number_of_users_answered"]];
    

//    self.numberOfPersonsLabel.text = totalNumbers;
   self.dateString = [NSString stringWithFormat:@"%@",[self.viewReportArray valueForKey:@"date"]];
//   self.dateString=[self.dateString substringToIndex:10];
    
    NSArray *arrSepValue;
    NSString *YourString = self.dateString;
    arrSepValue = [YourString componentsSeparatedByString:@" "];
    
    NSString *DateStr=[arrSepValue objectAtIndex:0];
    NSLog(@"Date String %@",DateStr);
   // [self setDate:self.dateString];
   
}

#pragma mark - Date Formatter

-(void) setDate:(NSString*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-d HH:mm:ss"];
    NSDate* myDate = [dateFormat dateFromString:date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [gregorian components:(NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear) fromDate:myDate];
    NSInteger day = [dateComponents day];
    dateFormat=nil;
    NSString *month;
    switch ([dateComponents month]) {
        case 1:
            month=@"Jan";
            break;
        case 2:
            month=@"Feb";
            break;
        case 3:
            month=@"Mar";
            break;
        case 4:
            month=@"Apr";
            break;
        case 5:
            month=@"May";
            break;
        case 6:
            month=@"Jun";
            break;
        case 7:
            month=@"Jul";
            break;
        case 8:
            month=@"Aug";
            break;
        case 9:
            month=@"Sep";
            break;
        case 10:
            month=@"Oct";
            break;
        case 11:
            month=@"Nov";
            break;
        case 12:
            month=@"Dec";
            break;
            
        default:
            month=nil;
            break;
    }
    self.dateElement.text=[NSString stringWithFormat:@"%ld %@ %ld",(long)day,month,(long)[dateComponents year]];
}
- (void)viewWillAppear:(BOOL)animated
{
    [self viewReportAPIcall];
    [self setUpImageBackButton];
    // self.questionLabel.text = [self.questionArray valueForKey:@"question"];
    //[self setDate:self.dateString];
}

-(void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
   // [self setDate:self.dateString];
}
#pragma mark - initialisation

-(void)initialisation
{
    self.viewReportTableView.delegate = self;
    self.viewReportTableView.dataSource = self;
    self.answersArray = [[NSMutableArray alloc]init];
}

#pragma mark - Customization

-(void)customization
{
    self.profileImageView.layer.cornerRadius = 20;
     self.profileImageView.layer.masksToBounds = YES;
//    self.numberOfPersonsLabel.text = [self.viewReportArray valueForKey:@"number_of_users_answered"];
//    self.tagElement.text = [NSString stringWithFormat:@"#%@",[self.viewReportArray valueForKey:@"tags"]];
}

#pragma mark - Add Constraints

-(void)addConstraints
{
    if (IS_IPHONE_6) {
        [self.greenLineLeadingSpace setConstant:150];
        [self.topViewBottomSpace setConstant:300];
    }
    else if (IS_IPHONE_6P)
    {
        [self.greenLineLeadingSpace setConstant:170];
        [self.topViewBottomSpace setConstant:300];
    }
    else if (IS_IPHONE_4_OR_LESS)
    {
        [self.topViewBottomSpace setConstant:100];
    }
    else if (IS_IPAD)
    {
        [self.greenLineLeadingSpace setConstant:350];
        [self.topViewBottomSpace setConstant:600];
        [self.questionLabelWidth setConstant:250];
        [self.dateLabelWidth setConstant:250];
    }
}

#pragma mark - navigation bar title

-(void)navigationBarTitle
{
    UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationItem.titleView.frame.size.width, 40)];
    label.text=self.navigationItem.title;
    label.textColor=[UIColor whiteColor];
    label.backgroundColor =[UIColor clearColor];
    label.adjustsFontSizeToFitWidth=YES;
    label.font = [UIFont fontWithName:QPMontserrat_Light size:20];
    label.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView=label;
}

#pragma mark - Setting navigation controller Back Button

- (void)setUpImageBackButton
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,10, 15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backArrow"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView datasources and delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Total Answered %lu",(unsigned long)self.answersArray.count);
//    if ([self.viewReportArray valueForKey:@"answers"]!=0) {
//        return 0;
//    }
//    else
//    {
//    return 0;
//    }
    if (self.answersArray.count== 0) {
        return 0;
    }
    else
         {
    return self.answersArray.count;
         }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    completeReportCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[completeReportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = @"QUE PICS";
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.answerNumberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    cell.answerNumberLabel.backgroundColor = [UIColor colorWithRed:0.153 green:0.69 blue:0.478 alpha:1];
    cell.answerNumberLabel.layer.cornerRadius = 13;
    cell.answerNumberLabel.textAlignment = NSTextAlignmentCenter;
    cell.answerNumberLabel.textColor = [UIColor whiteColor];
    cell.answerNumberLabel.clipsToBounds = YES;
   // cell.answerLabel.text = @"To my opiniion it is 30 days";
    cell.answerLabel.text = [[self.answersArray objectAtIndex:indexPath.row] valueForKey:@"answer"];
    NSString *numbersOfPersons = [NSString stringWithFormat:@"%@",[[self.answersArray objectAtIndex:indexPath.row] valueForKey:@"vote"]];
    cell.numberOfpersonsLabel.text = [NSString stringWithFormat:@"%@ persons answered this",numbersOfPersons] ;
    UIFont *yourFont = [UIFont fontWithName:@"Helvetica-BoldOblique"
                                       size:10];
    cell.numberOfpersonsLabel.font = yourFont;
    if (IS_IPAD) {
        UIFont *yourFontIpad = [UIFont fontWithName:@"Helvetica-BoldOblique"
                                           size:15];
        cell.numberOfpersonsLabel.font = yourFontIpad;
        UIFont *yourFontIpad2 = [UIFont fontWithName:@"Helvetica-BoldOblique"
                                               size:18
                    ];
        cell.answerLabel.font = yourFontIpad2;
        
        UIFont *yourFontIpad3 = [UIFont fontWithName:@"HelveticaNeue"
                                                size:18
                                 ];
        self.questionLabel.font = yourFontIpad3;
        
        UIFont *yourFontIpad4 = [UIFont fontWithName:@"HelveticaNeue"
                                                size:15
                                 ];
        self.dateElement.font = yourFontIpad4;
        
        UIFont *yourFontIpad5 = [UIFont fontWithName:@"Helvetica-BoldOblique"
                                                size:17
                                 ];
        self.tagElement.font = yourFontIpad5;
        
        
    }
    return cell;
}

#pragma mark - Table View Cell height

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
    
}

# pragma mark - dispaly cell table view

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
}

#pragma mark - View Report API call

-(void)viewReportAPIcall
{
    [self showLoadingMode];
    
    NSString *viewProfileURL = [NSString stringWithFormat:@"%@%@",BaseURL,ViewCompleReportAPI];
    NSString *finalViewProfileURL = [NSString stringWithFormat:@"%@%@",viewProfileURL,[[QPCommonClass initializeUserDefaults]valueForKey:@"currentquestionID"]];
    NSLog(@"Final View Report URL %@",finalViewProfileURL);
    NSURL *URL = [NSURL URLWithString:finalViewProfileURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    [request setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data != nil) {
            NSDictionary *dataJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            NSLog(@"%@", dataJSON);
            NSLog(@"Dictionary Count %lu",(unsigned long)[dataJSON count]);
            NSLog(@"ViewReport Details %@",[dataJSON valueForKey:@"questionDetails"]);
            NSLog(@"Asked Questions %@",[[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0]);
            NSLog(@"Answer Questions %@",[[[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0]valueForKey:@"answers"]);
             NSArray *answersArray1 = [[[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0]valueForKey:@"answers"];
            if (![answersArray1 isEqual:[NSNull null]]) {
//                for (int i= 0; i<[answersArray1 count]; i++) {
//                    
                    NSLog(@"Ansers Array Count %lu",(unsigned long)answersArray1.count);
                    [self.answersArray addObjectsFromArray:[[[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0]valueForKey:@"answers"]];
                    
//                }
            }

            
            
            self.viewReportArray = [[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0];
            NSLog(@"Tags %@",[NSString stringWithFormat:@"#%@",[self.viewReportArray valueForKey:@"tags"]]);
            
           NSLog(@"%@",self.viewReportArray);
        }
        [self hideLoadingMode];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *totalNumbers = [NSString stringWithFormat:@"%@",[self.viewReportArray valueForKey:@"number_of_users_answered"]];
                self.tagElement.text = [NSString stringWithFormat:@"#%@",[self.viewReportArray valueForKey:@"tags"]];
               
                
                
                self.numberOfPersonsLabel.text = totalNumbers;
                NSArray *arrSepValue;
                self.dateString = [NSString stringWithFormat:@"%@",[self.viewReportArray valueForKey:@"date"]];
                NSString *YourString = self.dateString;
                arrSepValue = [YourString componentsSeparatedByString:@" "];
                
                NSString *DateStr=[arrSepValue objectAtIndex:0];
                NSLog(@"Date String %@",DateStr);
                [self setDate:self.dateString];
              //  NSArray *answersArray = [[[dataJSON valueForKey:@"questionDetails"]objectAtIndex:0]valueForKey:@"answers"];
                [self.viewReportTableView reloadData];
                
            });

        
//        });
    }];
    [dataTask resume];
    
}


#pragma mark ActivityIndicator
-(void)showLoadingMode {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.qpActivityLoader setHidden:NO];
        [self flipAnimation];
    });
}
-(void) hideLoadingMode{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.qpActivityLoader setHidden:YES];
    });
    
}

-(void)flipAnimation
{
    [UIView transitionWithView:self.activityLoader
                      duration:1.3
                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionAllowAnimatedContent |UIViewAnimationOptionRepeat |   UIViewAnimationOptionBeginFromCurrentState
                    animations:^{
                        //  Set the new image
                        //  Since its done in animation block, the change will be animated
                        _activityLoader.image = [UIImage imageNamed:@"whitelogo "];
                        
                    } completion:^(BOOL finished) {
                        //  Do whatever when the animation is finished
                        _activityLoader.image = [UIImage imageNamed:@"qlogo"];
                        //[self RotateLogoD];
                    }];
}


-(void) qpSelectedQuetion:(NSString *)questionAsked;
{
    NSLog(@"Question Array in view report %@",questionAsked);
    self.questionLabel.text = questionAsked;
    self.questionString = questionAsked;
//    NSLog(@"Question %@",[questionAsked valueForKey:@"question"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
