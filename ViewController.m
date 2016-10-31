//
//  ViewController.m
//  Que Pics
//
//  Created by Apple on 05/10/15.
//  Copyright © 2015 AppZoc. All rights reserved.
//




#import "ViewController.h"
#import "QPCategoryViewController.h"
#import "QPCommonClass.h"
#import "OTWebServiceHelper.h"
#import "QPParameterDictionary.h"
#import "MZLoadingCircle.h"
#import "QPRegistrationController.h"
#import "QPGlobal.h"
@interface ViewController ()
{
    MZLoadingCircle *loadingCircle;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *logoImage;
@property (strong, nonatomic) IBOutlet UIView *loginview;
@property (strong, nonatomic) IBOutlet UITextField *qpUserName;
@property (strong, nonatomic) IBOutlet UITextField *qpPassword;
@property (strong, nonatomic) IBOutlet UIScrollView *qpLoginScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *passwordUnderLIne;
@property (strong, nonatomic) IBOutlet UIImageView *userNameUnderLine;
@property (strong, nonatomic) IBOutlet UIImageView *activityLoader;
@property (strong, nonatomic) IBOutlet UIView *qpActivityLoaderView;
@property (strong, nonatomic) NSString *alertControllerString;
@property (strong, nonatomic) UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScrollView;

//Constraints
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *notAMemberYetButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetPasswordButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetButttonTopSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *faceBookWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceFB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topspaceTwt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterLeadingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twitterTopSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTralingSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLeadingSpace;

- (IBAction)qpForgotPasswordAction:(id)sender;
@end

@implementation ViewController
#define logo_Width_Height 190
#define top_Spacing 20
#define top_Spacing_iPhone5 20
#define button_Height 32
#define forget_Password_Button_Height 40
#define logo_rotate_Angle 60

#pragma mark ViewController_Life_Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self addConstraints];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self animateLogo];
    [self setPlaceHolder];
    [self.navigationController setNavigationBarHidden:YES];
}

-(void)viewWillLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (IS_IPHONE_5_OR_LESS) {
        self.loginScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Custom_Functions
-(void) addConstraints{
    UIDevice *device = [UIDevice currentDevice];
    if (device.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_logoWidth setConstant:logo_Width_Height];
        [_logoHeight setConstant:logo_Width_Height];
        [_loginButtonSpacing setConstant:top_Spacing];
        [_forgetButttonTopSpacing setConstant:top_Spacing];
        [_loginButtonHeight setConstant:button_Height];
        [_notAMemberYetButtonHeight setConstant:button_Height];
        [_forgetPasswordButtonHeight setConstant:forget_Password_Button_Height];
        [self.faceBookWidth setConstant:137];
        [self.twitterButtonWidth setConstant:137];
        [self.twitterLeadingSpace setConstant:200];
        [_viewLeadingSpace setConstant:150];
        [_viewTralingSpace setConstant:150];
    }
    
    else if (IS_IPHONE_5)
    {
        [self.faceBookWidth setConstant:120];
        [self.twitterButtonWidth setConstant:120];
        [self.fbButtonHeight setConstant:30];
        [self.twitterButtonHeight setConstant:30];
        [self.twitterLeadingSpace setConstant:10];
        [self.topSpaceFB setConstant:5];
        [self.topspaceTwt setConstant:5];
        [_loginButtonHeight setConstant:button_Height];
        [_notAMemberYetButtonHeight setConstant:button_Height];
        [_loginButtonSpacing setConstant:top_Spacing_iPhone5];
        
    }
    else if (IS_IPHONE_6)
    {
        [self.faceBookWidth setConstant:134];
        [self.twitterButtonWidth setConstant:134];
        [_loginButtonHeight setConstant:button_Height];
        [_notAMemberYetButtonHeight setConstant:button_Height];
        [_loginButtonSpacing setConstant:top_Spacing];
        [self.twitterLeadingSpace setConstant:30];
    }
    else if (IS_IPHONE_6P)
    {
        [self.faceBookWidth setConstant:137];
        [self.twitterButtonWidth setConstant:137];
        [_loginButtonHeight setConstant:button_Height];
        [_notAMemberYetButtonHeight setConstant:button_Height];
        [_loginButtonSpacing setConstant:top_Spacing];
        [self.twitterLeadingSpace setConstant:67];
    }
    
    else if (IS_IPHONE_4_OR_LESS)
    {
        [self.faceBookWidth setConstant:120];
        [self.twitterButtonWidth setConstant:120];
        [self.twitterLeadingSpace setConstant:5];
        [self.fbButtonHeight setConstant:30];
        [self.twitterButtonHeight setConstant:30];
        [_loginButtonHeight setConstant:button_Height];
        [_notAMemberYetButtonHeight setConstant:button_Height];
        [_loginButtonSpacing setConstant:top_Spacing];
    }
   
}

-(CGSize) getDeviceSize{
    return [[UIScreen mainScreen] bounds].size;
}

-(void) setPlaceHolder{
    //Change Placeholder Color
    UIColor *color = [UIColor whiteColor];
    _qpUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username / Email Id" attributes:@{NSForegroundColorAttributeName: color}];
    _qpPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    //Change Cursor Color
    [[UITextField appearance] setTintColor:[UIColor  whiteColor]];
}

-(void) pushToCategoryViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        QPCategoryViewController *controller = (QPCategoryViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"categoryView"];
        controller.isFromRegistration = YES;
        [self.navigationController pushViewController:controller animated:YES];
    });
}
-(void) pushToRegisterViewController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        QPRegistrationController *controller = (QPRegistrationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"registerView"];;
        [self.navigationController pushViewController:controller animated:YES];
    });
}

#pragma mark Logo_Animation_And_Login_View
-(void) animateLogo{
    [self.logoImage setTransform:CGAffineTransformMakeScale(.5, .5)];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1.5, 1.5);
        CGAffineTransform rotateTrans = CGAffineTransformMakeRotation(logo_rotate_Angle * M_PI / 180);
        _logoImage.transform = CGAffineTransformConcat(scaleTrans, rotateTrans);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.logoImage setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:^(BOOL finished) {
            [self animationLoginView];
        }];
    }];
}
-(void) animationLoginView{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.loginview setAlpha:1.0];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark ActivityIndicator
-(void)showLoadingMode {
    [self.qpActivityLoaderView setHidden:NO];
    [self flipAnimation];
}
-(void) hideLoadingMode{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.qpActivityLoaderView setHidden:YES];
    });
    
}
#pragma mark UITextField_Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:_qpUserName]) {
        [_qpPassword becomeFirstResponder];
    }
    else{
        [self setScrollViewDown];
        [textField resignFirstResponder];
    }
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setScrollViewUp:textField.frame.origin.y + 50];
}

#pragma mark setScrollView_Animations

-(void) setScrollViewUp:(CGFloat)value{
    
   
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (IS_IPHONE_5) {
            [_qpLoginScrollView setContentOffset:CGPointMake(_qpLoginScrollView.frame.origin.x+4, _qpLoginScrollView.frame.origin.y + value) animated:YES];
        }
        else
            [_qpLoginScrollView setContentOffset:CGPointMake(_qpLoginScrollView.frame.origin.x+4, _qpLoginScrollView.frame.origin.y + value) animated:YES];
    } completion:^(BOOL finished) {
        
    }];
}
-(void) setScrollViewDown{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (IS_IPHONE_5) {
        [_qpLoginScrollView setContentOffset:CGPointMake(_qpLoginScrollView.frame.origin.x+4, _qpLoginScrollView.frame.origin.y) animated:YES];
        }
        else
            
            [_qpLoginScrollView setContentOffset:CGPointMake(_qpLoginScrollView.frame.origin.x, _qpLoginScrollView.frame.origin.y) animated:YES];
            
    } completion:^(BOOL finished) {
    }];
}
#pragma mark Button_Actions

- (IBAction)qpLoginButtonAction:(id)sender {
    NSLog(@"data %@",[NSData dataWithContentsOfURL:[[NSBundle mainBundle] appStoreReceiptURL]]);
    [self.view endEditing:YES];
    if (![QPCommonClass isEmptyString:_qpUserName.text] && ![QPCommonClass isEmptyString:_qpPassword.text]) {
        [self setScrollViewDown];
        [self showLoadingMode];
        [QPCommonClass disableUI];
        [[NSUserDefaults standardUserDefaults] setObject:_qpPassword.text forKey:@"userPassword"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"queLoggedIn"];
        NSString *post =[QPParameterDictionary loginParameters:_qpUserName.text mode:QuePicsLogin andPassword:_qpPassword.text];
        [OTWebServiceHelper sharedInstance].isFromLogin  =  YES;
        [[OTWebServiceHelper sharedInstance] qpPostToServerWithParameters:post andApi:LoginURL];
        NSLog(@"Post Dictionary %@",post);
        
        [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
            [self hideLoadingMode];
            [QPCommonClass enableUI];
            if (responseDict == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QPCommonClass showApplicationAlert:@"Network Error.Please try again" andTitle:@"Info" withDelegate:self];
                });
            }
            else if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
                NSLog(@"Success");
                NSLog(@"response dict %@", responseDict);
                NSLog(@"UserID%@",[responseDict objectForKey:@"user_id"] );
                [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"USER_ID"];
                [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] objectAtIndex:0]objectForKey:@"points" ]forKey:@"Points"];
                [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] objectAtIndex:0]objectForKey:@"user" ]forKey:@"Username"];
                [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] objectAtIndex:0]objectForKey:@"user_image" ]forKey:@"UserPhoto"];
                [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] objectAtIndex:0]objectForKey:@"email" ]forKey:@"Email"];
                [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] objectAtIndex:0]objectForKey:@"language" ]forKey:@"language"];
                [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"UserID"];
                [[NSUserDefaults standardUserDefaults] setObject:_qpPassword.text forKey:@"userPassword"];
                NSLog(@"Points %@",[[QPCommonClass initializeUserDefaults]valueForKey:@"Points"]);
                [self pushToCategoryViewController];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QPCommonClass showApplicationAlert:@"The email address entered or password does not appear to be valid" andTitle:@"Info" withDelegate:self];
                });
            }
        }];
    }
    else{
        [QPCommonClass isEmptyString:_qpUserName.text]?[QPCommonClass showApplicationAlert:@"The email address entered does not appear to be valid" andTitle:@"Info" withDelegate:self]:[QPCommonClass showApplicationAlert:@"The password entered does not appear to be valid" andTitle:@"Info" withDelegate:self];
    }
}

- (IBAction)qpForgotPasswordAction:(id)sender {
    
    
    if ([UIAlertController class]) {
        // use UIAlertController
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Send your password to:"
                                      message:@""
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Send" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       //Do Some action here
                                                       [self showLoadingMode];
                                                       [QPCommonClass disableUI];
                                                       self.emailTextField = [[UITextField alloc]init];
                                                       self.emailTextField = alert.textFields.firstObject;
                                                       NSLog(@"%@",self.emailTextField.text);
                                                       NSString *post =[QPParameterDictionary forgortPasswordParameters:self.emailTextField.text];
                                                       NSLog(@"Post %@",post);
                                                       [[OTWebServiceHelper sharedInstance] qpPostToServerWithParameters:post andApi:ForgotPassword];
                                                       [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
                                                           [self hideLoadingMode];
                                                           [QPCommonClass enableUI];
                                                           if ((![[responseDict valueForKey:@"status"] isEqualToString:@"True"]) || ([self.emailTextField.text isEqualToString:@""])) {
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [QPCommonClass showApplicationAlert:@"The email address entered does not appear to be valid, please verify the entered email address" andTitle:@"Info" withDelegate:self];
                                                               });
                                                           }
                                                           else{
                                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                                   [QPCommonClass showApplicationAlert:@"Please check your mail for password.Thank You." andTitle:@"Info" withDelegate:self];
                                                               });
                                                           }
                                                       }];
                                                       
                                                   }];
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        
        [alert addAction:ok];
        [alert addAction:cancel];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"E-mail address";
            
            
        }];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        // use UIAlertView
        UIAlertView *forgotPasswordAlert = [[UIAlertView alloc] initWithTitle:@"Send your password to:" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send", nil];
        forgotPasswordAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
        [forgotPasswordAlert show];
        forgotPasswordAlert = nil;
        
    }
    
}

- (IBAction)qpNotAMemberYetButtonAction:(id)sender {
    [self pushToRegisterViewController];
}

#pragma mark - Twitter Button Action

- (IBAction)twitterClick:(id)sender {
   // [self requestUserEmail];
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         //[self requestUserEmail];
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
                 NSLog(@"User image %@", user.profileImageURL);
                 NSLog(@"User image large %@", user.profileImageLargeURL);
                // [[QPCommonClass initializeUserDefaults]setObject:user.profileImageURL forKey:@"UserPhoto"];
                 [[QPCommonClass initializeUserDefaults]setObject:user.profileImageLargeURL forKey:@"UserPhoto"];
                 [self showLoadingMode];
                 
             }];
             
             
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"USER_ID"];
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"Username"];
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterLoggedIn"];
             [[NSUserDefaults standardUserDefaults]setObject:[session userName] forKey:TwitterUsername];
             [self requestUserEmail];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}


-(void)requestUserEmail
{
    //[[Twitter sharedInstance] startWithConsumerKey:@"iPAML98Ly4SGHxPfafdPeqmAa" consumerSecret:@"i09AQYkbUmBos5djVRaZMHhgebOif6nazzTPk9APmTjLkZj8Za"];
    if ([[Twitter sharedInstance] session]) {
        
        TWTRShareEmailViewController *shareEmailViewController =
        [[TWTRShareEmailViewController alloc]
         initWithCompletion:^(NSString *email, NSError *error) {
             NSLog(@"Email %@ | Error: %@", email, error);
             
             [self sendDataToServerForTwitter];
         }];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
            [self presentViewController:shareEmailViewController
                               animated:YES
                             completion:nil];
           
             });
    } else {
        // Handle user not signed in (e.g. attempt to log in or show an alert)
    }
}


#pragma mark - Facebook Button Action

- (IBAction)facebookClick:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             if ([FBSDKAccessToken currentAccessToken]) {
                 [self showLoadingMode];
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,picture.width(720).height(720),first_name"}]
                
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      
                      if (!error) {
                          
                          NSLog(@"fetched user:%@", result);
                          
                          NSLog(@"%@",result[@"email"]);
                          
                          NSLog(@"%@",[[result[@"picture"]valueForKey:@"data"]valueForKey:@"url"]);
                          [[QPCommonClass initializeUserDefaults] setObject:[[result[@"picture"]valueForKey:@"data"]valueForKey:@"url"] forKey:@"UserPhoto"];
                          [[NSUserDefaults standardUserDefaults]setObject:result[@"name"] forKey:FacebookUsername];
                         // NSLog(@"Facebook name %@",[responseDict objectForKey:@"user"]);
                          [[NSUserDefaults standardUserDefaults]setObject:result[@"email"] forKey:FacebookMailId];
                          [[QPCommonClass initializeUserDefaults]setObject:result[@"name"] forKey:@"USER_ID"];
                          [[QPCommonClass initializeUserDefaults]setObject:result[@"name"] forKey:@"Username"];
                          [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookLoggedIn"];
                          
                          [self sendDataToServerForFacebook];
                      }
                      
                  }];
             }
             //[self pushToCategoryViewController];
         }
     }];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        
        UITextField *emailTextField = [alertView textFieldAtIndex:0];
        NSLog(@"%@",emailTextField.text);
        [[QPCommonClass initializeUserDefaults]setObject:emailTextField.text forKey:@"TwitterEmail"];
        [self sendDataToServerForTwitter];
        
    }
    else{
        
    
    if (buttonIndex == 1) {
        [self showLoadingMode];
        [QPCommonClass disableUI];
        NSString *post =[QPParameterDictionary forgortPasswordParameters:[alertView textFieldAtIndex:0].text];
        [[OTWebServiceHelper sharedInstance] qpPostToServerWithParameters:post andApi:ForgotPassword];
        [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
            [self hideLoadingMode];
            [QPCommonClass enableUI];
            if ((![[responseDict valueForKey:@"status"] isEqualToString:@"True"]) || [[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QPCommonClass showApplicationAlert:@"The email address entered does not appear to be valid.Text the one you used to login." andTitle:@"Info" withDelegate:self];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [QPCommonClass showApplicationAlert:@"Please check your mail for password.Thank You." andTitle:@"Info" withDelegate:self];
                });
            }
        }];
    }
    }
}

#pragma mark - Loading Animations
-(void)flipAnimation
{
    [UIView transitionWithView:self.activityLoader
                      duration:1.3
                       options:UIViewAnimationOptionTransitionFlipFromRight|UIViewAnimationOptionRepeat |   UIViewAnimationOptionBeginFromCurrentState
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

#pragma mark - Sending Data To server for Facebook

-(void)sendDataToServerForFacebook
{
    
    NSString *password = @"";
    [[NSUserDefaults standardUserDefaults] setObject:_qpPassword.text forKey:@"userPassword"];
    NSString *post =[QPParameterDictionary loginParameters:[[NSUserDefaults standardUserDefaults]valueForKey:FacebookUsername] mode:FacebookLogin andPassword:password];
    [OTWebServiceHelper sharedInstance].isFromLogin  =  YES;
    NSLog(@"%@",post);
    [[OTWebServiceHelper sharedInstance] qpPostToServerWithParameters:post andApi:LoginURL];
    
    [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
        [self hideLoadingMode];
        [QPCommonClass enableUI];
        if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
            NSLog(@"Success");
            NSLog(@"response dict %@",responseDict);
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"USER_ID"];
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"UserID"];
            
            NSLog(@"Facebook name %@",[[[responseDict objectForKey:@"user_details"]objectAtIndex:0]valueForKey:@"user"]);
            NSString *facebookname = [[[responseDict objectForKey:@"user_details"]objectAtIndex:0]valueForKey:@"user"];
            [[QPCommonClass initializeUserDefaults] setObject:facebookname forKey:@"SettingsFacebookName"];
           // [[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] lastObject] valueForKey:@"user_image"] forKey:@"UserPhoto"];
          //  [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_image"] forKey:@"UserPhoto"];
            [self pushToCategoryViewController];
        }
        else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [QPCommonClass showApplicationAlert:@"This Facebook account is not registered, please register from the registration page." andTitle:@"Info" withDelegate:self];
                        });
        }
    }];
    
    
    
    
}


#pragma mark - Sending Data To server for Twitter

// Editted by abhijith

-(void)sendDataToServerForTwitter
{
    NSString *password = @"";
    [[NSUserDefaults standardUserDefaults] setObject:_qpPassword.text forKey:@"userPassword"];
    NSString *post =[QPParameterDictionary loginParameters:[[NSUserDefaults standardUserDefaults]valueForKey:TwitterUsername] mode:TwitterLogin andPassword:password];
    NSLog(@"POST %@",post);
    [OTWebServiceHelper sharedInstance].isFromLogin  =  YES;
    [[OTWebServiceHelper sharedInstance] qpPostToServerWithParameters:post andApi:LoginURL];
    
    [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
        NSLog(@"Response Dict %@",responseDict);
        [self hideLoadingMode];
        [QPCommonClass enableUI];
        if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
            NSLog(@"Success");
             NSLog(@"response dict %@",responseDict);
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"USER_ID"];
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"UserID"];
            //[[QPCommonClass initializeUserDefaults] setObject:[[[responseDict objectForKey:@"user_details"] lastObject] valueForKey:@"user_image"] forKey:@"UserPhoto"];
            //  [[QPCommonClass initializeUserDefaults] setObject:[responseDict ob;
            [self pushToCategoryViewController];
            //[self showAlertForEmail];
        }
        else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [QPCommonClass showApplicationAlert:@"This Twitter account is not registered, please register from the registration page." andTitle:@"Info" withDelegate:self];
                        });
        }
    }];
    
    
    
    
}

#pragma mark - Show Alert for email

-(void)showAlertForEmail
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Enter your registered twitter email:" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.tag = 1;
    [alertView show];
}


@end
