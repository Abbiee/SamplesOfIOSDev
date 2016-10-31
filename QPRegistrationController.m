//
//  RegistrationController.m
//  Que Pics
//
//  Created by Zoccer Capitan 1 on 09/10/15.
//  Copyright © 2015 AppZoc. All rights reserved.
//

//#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
//
//#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
//#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
//#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//#define IS_PAD_Mini ( [ [ UIScreen mainScreen ] bounds ].size.height == 512 )
//
//#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
//#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//
//#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
//#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
//#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define ImagePickerOrginalImage @"UIImagePickerControllerOriginalImage"
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define DEGREES_IN_RADIANS(x) (M_PI * x / 180.0);
#define kPassword @"password"
#define UserPhotoName @"UserPhoto.png"
#define AppTitle @"Que Pics"

#import "QPRegistrationController.h"
#import "ImageCache.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <TwitterKit/TwitterKit.h>
#import "NSString+Extension.h"
#import "Constants.h"
#import "OTWebServiceHelper.h"
#import "UIView+i7Rotate360.h"
#import "UIView+Glow.h"
#import "QPCommonClass.h"
#import "QPCategoryViewController.h"
#import "QPGlobal.h"
#import "UINavigationController+QPCustomizing.h"
#import "AZMD5Generator.h"
#import "QPLanguageSettingsController.h"

@interface QPRegistrationController ()<UIGestureRecognizerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;

@property (weak, nonatomic) IBOutlet UIImageView *emailUnderline;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIScrollView *registerScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *activityLoader;
@property (strong, nonatomic) IBOutlet UIView *qpActivityLoaderView;

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *notAMemberYetButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetPasswordButtonHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *loginButtonSpacing;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *forgetButttonTopSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twButtonWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fbButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twButtonHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *signupHeight;

@property(nonatomic,strong)UITapGestureRecognizer *tapGestureRecogonizer;
@property(nonatomic,strong)UIActionSheet *cameraActionSheet;
@property(nonatomic,strong)UIPickerView *countryPickerView;
@property(nonatomic,strong)NSArray *allCountries;
@property(nonatomic,strong)UIImagePickerController *proPickPickerController;
@property(nonatomic,strong)UIPopoverController *popOverController;
@property(nonatomic)BOOL isClickedCamera;
@property(nonatomic,strong)dispatch_queue_t imageQueue;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *registerviewBottomSpace;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *horizontalspacingButtons;
@property (strong, nonatomic) UITextField *twitterTextField;
@property (strong, nonatomic) IBOutlet UITextView *preffredLanguageTextView;
@property (strong, nonatomic) NSDictionary *details;

@end

@implementation QPRegistrationController

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initialisation];
    [self addConstraints];
    [self customization];
    [self keybaordScrolling];
   
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.title = @"Sign Up";
    [self navigationBarTitle];
   
    
    
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(show)];
    [gr setNumberOfTapsRequired:1];
    [_preffredLanguageTextView addGestureRecognizer:gr];
    self.imageQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.isClickedCamera = NO;
    self.emailTextField.delegate = self;
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confirmTextField.delegate = self;
    [self.registerView setAlpha:0];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //[self animateLogo];
    [self setPlaceHolder];
    [self animateLogo];
    [self setUpImageBackButton];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (IS_IPHONE_5_OR_LESS) {
        self.registerScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + 100);
    }
    
}

#pragma mark initialisation

-(void)initialisation
{
    self.proPickPickerController = [[UIImagePickerController alloc] init];
    self.proPickPickerController.allowsEditing = YES;
    self.proPickPickerController.delegate = self;
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
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,12, 17)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = barBackButtonItem;
    self.navigationItem.hidesBackButton = YES;
}


-(void)show
{
    NSLog(@"Tap tracked");
   
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            QPLanguageSettingsController *controller = (QPLanguageSettingsController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"languageSettings"];
            controller.delegate = self;
            [self.navigationController pushViewController:controller animated:YES];
            
            
        });
    
}

#pragma mark - language selection delegate

-(void)sendDataBack:(NSString *)passedString
{
    NSLog(@"Language string in first view controller %@",passedString);
    if ([passedString length] == 0 )
    {
        self.preffredLanguageTextView.text = @"ENGLISH";
    }
    else
    {
    self.preffredLanguageTextView.text = passedString;
    }
}
- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Setting placeholder color

-(void) setPlaceHolder{
    //Change Placeholder Color
    UIColor *color = [UIColor whiteColor];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter your email" attributes:@{NSForegroundColorAttributeName: color}];
     _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter a username" attributes:@{NSForegroundColorAttributeName: color}];
     _passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter a password" attributes:@{NSForegroundColorAttributeName: color}];
     _confirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm password" attributes:@{NSForegroundColorAttributeName: color}];
   
    //Change Cursor Color
    [[UITextField appearance] setTintColor:[UIColor  whiteColor]];
}

#pragma mark - setting constraints

-(void) addConstraints{
    UIDevice *device = [UIDevice currentDevice];
    if (device.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [_fbButtonWidth setConstant:330];
        [_twButtonWidth setConstant:343];
        [_fbButtonHeight setConstant:91];
        [_twButtonHeight setConstant:91];
        [_signupHeight setConstant:80];
        if (SYSTEM_VERSION_LESS_THAN(@"8.0"))
        {
            [self.registerviewBottomSpace setConstant:-31];
            [self.horizontalspacingButtons setConstant:28];
        }

    }
    
    else if (IS_IPHONE_6)
    {
        [_fbButtonWidth setConstant:140];
        [_twButtonWidth setConstant:148];
        [_fbButtonHeight setConstant:40];
        [_twButtonHeight setConstant:40];
            
    }
    
    else if (IS_IPHONE_6P)
    {
        [_fbButtonWidth setConstant:148];
        [_twButtonWidth setConstant:170];
        [_fbButtonHeight setConstant:40];
        [_twButtonHeight setConstant:40];
        

    }
    else if (IS_IPHONE_5)
    {
        [_hintTextViewWidth setConstant:180];
        [_prefferedLanguageHeight setConstant:35];
    }
}


#pragma mark - Customization of view elements

-(void)customization
{
    self.logoImageView.layer.cornerRadius = 75;
    [self.logoImageView setUserInteractionEnabled:YES];
    self.logoImageView.clipsToBounds = YES;
    self.tapGestureRecogonizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
    self.tapGestureRecogonizer.delegate = self;
    [self.logoImageView addGestureRecognizer:self.tapGestureRecogonizer];
    self.passwordTextField.autocorrectionType= UITextAutocorrectionTypeNo;
    self.confirmTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.passwordTextField.secureTextEntry = YES;
    self.confirmTextField.secureTextEntry = YES;
    self.passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.confirmTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameTextField.autocorrectionType = UITextSpellCheckingTypeNo;
    self.emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    
//    self.preffredLanguageTextView.layer.borderWidth = 1.0f;
//    self.preffredLanguageTextView.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}


#pragma mark - UIActionSheet

- (void)imageViewTapped:(id) sender{
    [self showActionSheet];
    [self.confirmTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
   //[self rotateLogoImageVIew];
}


-(void)rotateLogoImageVIew
{
    [UIView animateWithDuration:1.0 animations:^{
        
        CATransition *animation=[CATransition animation];
        [animation setDelegate:self];
        [animation setDuration:1.75];
        [animation setTimingFunction:UIViewAnimationCurveEaseInOut];
        [animation setType:@"rippleEffect"];
        
        [self.logoImageView.layer addAnimation:animation forKey:nil];
        
    } completion:nil];
}
- (void)showActionSheet{
    
    if (IS_IPAD) {
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"Options"
                                     message:@""
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"Take Photo"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                                     [self showPickerFromPhotoLibrary];
                                     self.isClickedCamera = YES;
                                 }
                                 else{
                                     UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Oops...!" message:@"This device does not have a camera attached!! Try using a picture from gallery" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                                     [alertView show];
                                 }
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Choose Photo"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                     [self showPickerFromPhotoLibrary];
                                     
                                 }];
        
        
        [view addAction:ok];
        [view addAction:cancel];
        
        view.popoverPresentationController.sourceView = self.view;
        view.popoverPresentationController.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0 - 165, 0.5, 1.0);
        [self presentViewController: view animated:YES completion:nil];
        
    }
    else{
        NSString *actionSheetTitle = @"Options";
        NSString *takePicture = @"Take Picture";
        NSString *choosePicture = @"Choose Picture";
        NSString *cancelTitle = @"Cancel";
        self.cameraActionSheet = [[UIActionSheet alloc]
                                  initWithTitle:actionSheetTitle
                                  delegate:self
                                  cancelButtonTitle:cancelTitle
                                  destructiveButtonTitle:takePicture
                                  otherButtonTitles:choosePicture,nil];
        [self.cameraActionSheet showInView:self.view];
    }
}

-(void) takePhoto{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self showPickerFromPhotoLibrary];
        self.isClickedCamera = YES;
    }
    else{
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Oops...!" message:@"This device does not have a camera attached!! Try using a picture from gallery" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
-(void) choosePhoto{
    self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self showPickerFromPhotoLibrary];
}

#pragma mark - UIActionSheet Delegate


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    switch (buttonIndex) {
        case 0:
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self showPickerFromPhotoLibrary];
                self.isClickedCamera = YES;
            }
            else{
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Oops...!" message:@"This device does not have a camera attached!! Try using a picture from gallery" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
            }
            //            [self presentViewController:self.proPickPickerController animated:YES completion:nil];
            break;
        case 1:{
            self.proPickPickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self showPickerFromPhotoLibrary];
            break;
        }
        case 2:
            
            break;
        default:
            break;
    }
    
}



-(void)presentCameraView{
    if(IS_IPAD) {
        self.popOverController= [[UIPopoverController alloc]initWithContentViewController:self.proPickPickerController];
        [self.popOverController presentPopoverFromRect:self.logoImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (IS_IPHONE) {
        [self presentViewController:self.proPickPickerController animated:YES completion:nil];
    }
    
}
#pragma mark - ShowPhotoLibrary

- (void)showPickerFromPhotoLibrary {
    if(IS_IPAD) {
        self.popOverController= [[UIPopoverController alloc]initWithContentViewController:self.proPickPickerController];
        [self.popOverController presentPopoverFromRect:self.logoImageView.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
    else if (IS_IPHONE) {
        [self presentViewController:self.proPickPickerController animated:YES completion:nil];
    }
}
#pragma mark - UIImagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.logoImageView.frame.size.width / 2.0, self.logoImageView.frame.size.height / 2.0);;
    [self.logoImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    CGRect imageRect = [[info valueForKey:UIImagePickerControllerCropRect] CGRectValue];
    UIImage * fixedImage = [self fixOrientation:[info valueForKey:UIImagePickerControllerOriginalImage] withFrame:imageRect ];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        dispatch_async(self.imageQueue, ^{
            NSString *imagePath ;
            if (self.isClickedCamera) {
                UIImageWriteToSavedPhotosAlbum([info valueForKey:ImagePickerOrginalImage], nil, nil, nil);
                imagePath = [[ImageCache sharedCache] addImage:fixedImage toCacheWithIdentifier:UserPhotoName];
               
            }
            else{
                imagePath = [[ImageCache sharedCache] addImage:fixedImage toCacheWithIdentifier:UserPhotoName];
            }
        });
        [activityIndicator stopAnimating];
        self.logoImageView.image =fixedImage;
        
    }
    else{
        NSString *imagePath;
       imagePath = [[ImageCache sharedCache] addImage:[info valueForKey:ImagePickerOrginalImage] toCacheWithIdentifier:UserPhotoName];
        [activityIndicator stopAnimating];
        self.logoImageView.image = [[ImageCache sharedCache]imageFromCacheWithIdentifier:UserPhotoName];
        NSLog(@"Image Path %@",imagePath);
        
    }
    [self.proPickPickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.isClickedCamera = NO;
}

#pragma mark - FixImageOrientation

- (UIImage *)fixOrientation:(UIImage *) currentImage withFrame:(CGRect) rect{
    UIImage *image = currentImage;
    CGSize imageSize = image.size;
    CGRect cropRect = rect;
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImageOrientation orientation = [image imageOrientation];
    if (orientation == UIImageOrientationUp) {
        CGContextTranslateCTM(context, 0, imageSize.height);
        CGContextScaleCTM(context, 1, -1);
        cropRect = CGRectMake(cropRect.origin.x, -cropRect.origin.y, cropRect.size.width, cropRect.size.height);
        
    }else if (orientation == UIImageOrientationRight){
        CGContextScaleCTM(context, 1, -1);
        CGContextRotateCTM(context,- M_PI/2);
        imageSize = CGSizeMake(imageSize.height, imageSize.width);
        cropRect = CGRectMake(cropRect.origin.y, cropRect.origin.x, cropRect.size.height, cropRect.size.width);
    }
    else if (orientation == UIImageOrientationDown){
        CGContextTranslateCTM(context, imageSize.width, 0);
        CGContextScaleCTM(context, -1.0, 1.0);
        cropRect = CGRectMake(-cropRect.origin.x,cropRect.origin.y, cropRect.size.width, cropRect.size.height);
    }
    
    CGContextTranslateCTM(context, -cropRect.origin.x, -cropRect.origin.y);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), image.CGImage);
    UIImage *croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return croppedImage;
}

#pragma mark - SignUp Button Action

- (IBAction)signUpButtonAction:(id)sender {
    if ([self validateData]) {
        [self.view endEditing:YES];
        [self showLoadingMode];
        [QPCommonClass disableUI];
        [self sendDatatoServer];
        }
    

}
#pragma mark - Facebook Button Action

- (IBAction)fbLoginAction:(id)sender {
    
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
                          
                          [[QPCommonClass initializeUserDefaults]setObject:result[@"name"] forKey:@"USER_ID"];
                          [[QPCommonClass initializeUserDefaults]setObject:result[@"name"] forKey:@"Username"];
                          [[NSUserDefaults standardUserDefaults]setObject:result[@"name"] forKey:FacebookUsername];
                          [[NSUserDefaults standardUserDefaults]setObject:result[@"email"] forKey:FacebookMailId];
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"facebookLoggedIn"];
                           [self sendDataToServerForFacebook];
                      }
                      
                  }];
             }
             //[self pushToCategoryViewController];
         }
     }];
}

#pragma mark - Twitter Button Action

- (IBAction)twitterButtonAction:(id)sender {
    
    [[Twitter sharedInstance] logInWithCompletion:^
     (TWTRSession *session, NSError *error) {
         if (session) {
             NSLog(@"signed in as %@", [session userName]);
             [[[Twitter sharedInstance] APIClient] loadUserWithID:session.userID completion:^(TWTRUser *user, NSError *error) {
                 NSLog(@"User image %@", user.profileImageURL);
                  NSLog(@"User image large %@", user.profileImageLargeURL);
                 //[[QPCommonClass initializeUserDefaults]setObject:user.profileImageURL forKey:@"UserPhoto"];
                 [[QPCommonClass initializeUserDefaults]setObject:user.profileImageLargeURL forKey:@"UserPhoto"];
                  [self showLoadingMode];
             }];
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"USER_ID"];
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"Username"];
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"USER_ID"];
             [[QPCommonClass initializeUserDefaults]setObject:[session userName] forKey:@"Username"];
             [[NSUserDefaults standardUserDefaults]setObject:[session userName] forKey:TwitterUsername];
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterLoggedIn"];
            // [self pushToCategoryViewController];
             //[self showAlertForEmail];
             //[self sendDataToServerForTwitter];
             [self requestUserEmail];
         } else {
             NSLog(@"error: %@", [error localizedDescription]);
         }
     }];
}

-(void)requestUserEmail
{
   // [[Twitter sharedInstance] startWithConsumerKey:@"iPAML98Ly4SGHxPfafdPeqmAa" consumerSecret:@"i09AQYkbUmBos5djVRaZMHhgebOif6nazzTPk9APmTjLkZj8Za"];
    if ([[Twitter sharedInstance] session]) {
        
        TWTRShareEmailViewController *shareEmailViewController =
        [[TWTRShareEmailViewController alloc]
         initWithCompletion:^(NSString *email, NSError *error) {
             NSLog(@"Email %@ | Error: %@", email, error);
                [[QPCommonClass initializeUserDefaults]setObject:email forKey:@"TwitterEmailMain"];
             if ([[QPCommonClass initializeUserDefaults]valueForKey:@"TwitterEmailMain"] != nil) {
                 [self sendDataToServerForTwitter];
             }
            // [self sendDataToServerForTwitter];
         }];
        
//        [self presentViewController:shareEmailViewController
//                           animated:YES
//                         completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [self presentViewController:shareEmailViewController
                               animated:YES
                             completion:nil];

        });

        
    } else {
        // Handle user not signed in (e.g. attempt to log in or show an alert)
    }
}


-(void) animateLogo{
    [self.logoImageView setTransform:CGAffineTransformMakeScale(.5, .5)];
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CGAffineTransform scaleTrans = CGAffineTransformMakeScale(1.5, 1.5);
        CGAffineTransform rotateTrans = CGAffineTransformMakeRotation(60 * M_PI / 180);
        _logoImageView.transform = CGAffineTransformConcat(scaleTrans, rotateTrans);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.logoImageView setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:^(BOOL finished) {
            [self animationLoginView];
        }];
    }];
}


#pragma mark - Animation
-(void) animationLoginView{
    [UIView animateWithDuration:0.5 delay:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.registerView setAlpha:1.0];
    } completion:^(BOOL finished) {
        
       // [self shakeAnimation];
    }];
}

#pragma mark - Shake Animation

-(void)shakeAnimation
{
    //Shake screen
    self.registerView.transform = CGAffineTransformMakeTranslation(20, 0);
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.registerView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished)
     
     {
         if (finished)
         {
             [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
              {
                  self.registerView.transform = CGAffineTransformIdentity;
              }
                              completion:NULL];
         }
     }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KeyBoard Scrolling

-(void)keybaordScrolling
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Notification methods

- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    UIEdgeInsets contentInset = self.registerScrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.registerScrollView.contentInset = contentInset;
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.registerScrollView.contentInset = contentInsets;
}

#pragma mark TextField Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField){
        [self.emailTextField resignFirstResponder];
        [self.usernameTextField becomeFirstResponder];
        }
    else if (textField == self.usernameTextField) {
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
       }
    else if (textField == self.passwordTextField){
        [self.passwordTextField resignFirstResponder];
        [self.confirmTextField becomeFirstResponder];
       }
    else if ([textField isEqual:self.confirmTextField]){
        [self.confirmTextField resignFirstResponder];
       }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.returnKeyType = UIReturnKeyNext;
    if ([textField isEqual:self.emailTextField]) {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        return YES;
    }
    if ([textField isEqual:self.confirmTextField]) {
        textField.returnKeyType = UIReturnKeyDone;
    }
    return YES;
}

#pragma mark - Text Fields Validation

- (BOOL)validateData{
    BOOL isValid = YES;
    if ([self.emailTextField.text empty]){
        isValid = NO;
        UIAlertView *emailAlert = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Please provide email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.emailTextField becomeFirstResponder];
        [emailAlert show];
    }
       else if (![self.emailTextField.text validEmail] ) {
        isValid = NO;
        UIAlertView *emailAlert1 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Invalid Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.emailTextField becomeFirstResponder];
        [emailAlert1 show];
    }
    else if ([self.usernameTextField.text empty]){
        isValid = NO;
        UIAlertView *userAlert = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Please provide Username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.usernameTextField becomeFirstResponder];
        [userAlert show];
    }
    else if (![self.usernameTextField.text validName]){
        isValid = NO;
        UIAlertView *userAlert1 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Enter User name without space and special character" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.usernameTextField becomeFirstResponder];
        [userAlert1 show];
    }
    else if ([self.usernameTextField.text length]<3){
        isValid = NO;
        UIAlertView *userAlert2 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Username should be between 3-15 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.usernameTextField becomeFirstResponder];
        [userAlert2 show];
    }
    else if ([self.usernameTextField.text length]>15){
        isValid = NO;
        UIAlertView *userAlert3 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Username should be between 3-15 characters" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.usernameTextField becomeFirstResponder];
        [userAlert3 show];
    }
    else if ([self.usernameTextField.text empty]){
        isValid = NO;
        UIAlertView *userAlert4 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Empty Username" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.usernameTextField becomeFirstResponder];
        [userAlert4 show];
        
    }
    else if ([self.passwordTextField.text empty]){
        isValid = NO;
        UIAlertView *passwordAlert = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Empty Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.passwordTextField becomeFirstResponder];
        [passwordAlert show];
        
    }
    else if ([self.passwordTextField.text length]<8){
        isValid = NO;
        UIAlertView *passwordAlert1 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Password should be of minimum eight characters length." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.passwordTextField becomeFirstResponder];
        [passwordAlert1 show];
    }
    else if (![self validatePassword:self.passwordTextField.text]){
        isValid = NO;
//        UIAlertView *passwordAlert2 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Password should only consist of alphabets or numbers or both with minimum eight characters length. No special characters allowed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
         UIAlertView *passwordAlert2 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Password should be of minimum eight characters length." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.passwordTextField becomeFirstResponder];
        [passwordAlert2 show];
    }
    else if ([self.confirmTextField.text empty]){
        isValid = NO;
        UIAlertView *passwordAlert3 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Empty Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.confirmTextField becomeFirstResponder];
        [passwordAlert3 show];
    }
    else if (![self validatePassword:self.confirmTextField.text]){
        isValid = NO;
        UIAlertView *passwordAlert4 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Password should be of minimum eight characters length." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.confirmTextField becomeFirstResponder];
        [passwordAlert4 show];
    }
//    else if ([self.confirmTextField.text length]<8){
//        isValid = NO;
//        UIAlertView *passwordAlert5 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Confirm Password should be alphanumeric with minimum eight characters length" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [self.confirmTextField becomeFirstResponder];
//        [passwordAlert5 show];
//    }
    else if (![self.passwordTextField.text isEqualToString:self.confirmTextField.text]){
        isValid = NO;
        UIAlertView *passwordAlert6 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Password and confirm password  mismatch" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.passwordTextField becomeFirstResponder];
        [passwordAlert6 show];
    }
    return isValid;
}

#pragma mark - Password Validation Logic

//- (BOOL)validatePassword:(NSString *) password{
//    //NSString *ACCEPTABLE_CHARECTERS = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
//    NSString *ACCEPTABLE_CHARECTERS = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!~`@#$%^&*-+();:={}[],.<>?\\/\"\'_|";
//    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
//    NSString *filtered = [[password componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//    return [password isEqualToString:filtered];
//}

- (BOOL)validatePassword:(NSString *) password{
    if(password.length == 0){
        return NO;
    }
//    NSString *regex = @"^(?=(.*\d){2})(?=.*[a-zA-Z])(?=.*[!@#$%])[0-9a-zA-Z!@#$%]{8,}";
//    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [passwordPredicate evaluateWithObject:password];
    
    return YES;
}
#pragma mark - Send data to server

-(void)sendDatatoServer
{
   // NSString  *currentDeviceId = [QPCommonClass getDeviceId];
     NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyAppDeviceToken"];
    NSLog(@"Device token %@",deviceToken);
    NSString *isIOSDevice = [NSString stringWithFormat:@"%@",@"IOS"];
    if ([_preffredLanguageTextView.text  isEqual: @"Preffered Languages     >"]) {
        _details = @{@"user":self.usernameTextField.text,
                                  @"email":self.emailTextField.text,@"password":self.passwordTextField.text,@"preference":@"JAVA",@" language":@"ENGLISH", @"device_id":deviceToken,@"mode":QuePicsLogin,@"phone_type":isIOSDevice,
                                  @"unix_time":[AZMD5Generator generateEpochTime],
                                  @"tokenkey":[AZMD5Generator generateMD5String]
                                  };
    }
    else
    {
    _details = @{@"user":self.usernameTextField.text,
                            @"email":self.emailTextField.text,@"password":self.passwordTextField.text,@"preference":@"JAVA",@" language":self.preffredLanguageTextView.text, @"device_id":deviceToken,@"mode":QuePicsLogin,@"phone_type":isIOSDevice,
                              @"unix_time":[AZMD5Generator generateEpochTime],
                              @"tokenkey":[AZMD5Generator generateMD5String]
                              };
    }
   // [[OTWebServiceHelper sharedInstance] cleanUpWebServiceRequest];
    [[OTWebServiceHelper sharedInstance] postImage:self.logoImageView.image andDetails:_details apiUrl:RegisterURL imageKey:@"user_image"];
    [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
        [QPCommonClass enableUI];
        [self hideLoadingMode];
        if (responseDict == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [QPCommonClass showApplicationAlert:@"Network Error.Please try again" andTitle:@"Info" withDelegate:self];
            });
        }
        else if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
            NSLog(@"Success");
            NSArray *userDetails = [responseDict valueForKey:@"user_details"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"user_id"] forKey:@"USER_ID"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"points"] forKey:@"Points"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"user"] forKey:@"Username"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"user_image"] forKey:@"UserPhoto"];
             [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"email"] forKey:@"Email"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"userPassword"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"queLoggedIn"];
            [self pushToCategoryViewController];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QPCommonClass showApplicationAlert:@"Sorry!!! This email or username is already in use,please create new one." andTitle:@"Info" withDelegate:self];
            });
        }
        
    }];
    [[OTWebServiceHelper sharedInstance] setOnFailure:^(NSError *errorDict){

    }];

   
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Preffered Languages"]) {
        textView.text = @"";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Preferred Languages";
        textView.textColor = [UIColor whiteColor]; //optional
    }
    [textView resignFirstResponder];
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
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userPassword"];
    NSLog(@"User Photo %@",[[QPCommonClass initializeUserDefaults]valueForKey:@"UserPhoto"]);
   // UIDevice *device = [UIDevice currentDevice];
   // NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyAppDeviceToken"];
    NSString *isIOSDevice = [NSString stringWithFormat:@"%@",@"IOS"];
    NSDictionary *details = @{@"user":[[NSUserDefaults standardUserDefaults] valueForKey:FacebookUsername],
                              @"email":[[NSUserDefaults standardUserDefaults] valueForKey:FacebookMailId],@"password":password,@"preference":@"JAVA",@" language":@"ENGLISH", @"device_id":deviceToken,@"mode":FacebookLogin,@"phone_type":isIOSDevice,@"unix_time":[AZMD5Generator generateEpochTime],
                              @"tokenkey":[AZMD5Generator generateMD5String]
                              };
    NSLog(@"FDetails %@",details);
    // [[OTWebServiceHelper sharedInstance] cleanUpWebServiceRequest];
    [[OTWebServiceHelper sharedInstance] postImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[QPCommonClass initializeUserDefaults]valueForKey:@"UserPhoto"]]]] andDetails:details];
    [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
        [QPCommonClass enableUI];
        [self hideLoadingMode];
        if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
            NSLog(@"Success");
            NSArray *userDetails = [responseDict valueForKey:@"user_details"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"user_id"] forKey:@"USER_ID"];
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"UserID"];
            
            NSString *facebookname = [[[responseDict objectForKey:@"user_details"]objectAtIndex:0]valueForKey:@"user"];
            [[QPCommonClass initializeUserDefaults] setObject:facebookname forKey:@"SettingsFacebookName"];
            [self pushToCategoryViewController];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QPCommonClass showApplicationAlert:@"Sorry!!! This email or username is already in use,please create new one." andTitle:@"Info" withDelegate:self];
            });
        }
        
    }];
    [[OTWebServiceHelper sharedInstance] setOnFailure:^(NSError *errorDict){
        
    }];
    
}

#pragma mark - Sending Data To server for Twitter

-(void)sendDataToServerForTwitter
{
    NSString *password = @"";
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:@"userPassword"];
    //NSString *twitterEmail = [NSString stringWithFormat:@"%@gmail.com",[[NSUserDefaults standardUserDefaults] valueForKey:TwitterUsername]];
    NSString *twitterEmail =  [[QPCommonClass initializeUserDefaults]valueForKey:@"TwitterEmailMain"];
    
    //UIDevice *device = [UIDevice currentDevice];
   // NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyAppDeviceToken"];
    NSString *isIOSDevice = [NSString stringWithFormat:@"%@",@"IOS"];
    NSDictionary *details = @{@"user":[[NSUserDefaults standardUserDefaults] valueForKey:TwitterUsername],
                              @"email":twitterEmail,@"password":password,@"preference":@"JAVA",@" language":@"ENGLISH", @"device_id":deviceToken,@"mode":TwitterLogin,@"phone_type":isIOSDevice,@"unix_time":[AZMD5Generator generateEpochTime],
                              @"tokenkey":[AZMD5Generator generateMD5String]
                              };
    NSLog(@"TDetails %@",details);
    // [[OTWebServiceHelper sharedInstance] cleanUpWebServiceRequest];
    [[OTWebServiceHelper sharedInstance] postImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[QPCommonClass initializeUserDefaults]valueForKey:@"UserPhoto"]]]] andDetails:details];
    [[OTWebServiceHelper sharedInstance] setOnSuccess:^(NSDictionary *responseDict){
        [QPCommonClass enableUI];
        [self hideLoadingMode];
        if (![[responseDict valueForKey:@"status"] isEqualToString:@"False"]) {
            NSLog(@"Success");
            NSArray *userDetails = [responseDict valueForKey:@"user_details"];
            [[QPCommonClass initializeUserDefaults] setObject:[[userDetails lastObject] objectForKey:@"user_id"] forKey:@"USER_ID"];
            [[QPCommonClass initializeUserDefaults] setObject:[responseDict objectForKey:@"user_id"] forKey:@"UserID"];
            [self pushToCategoryViewController];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [QPCommonClass showApplicationAlert:@"Sorry!!! This email or username is already in use,please create new one." andTitle:@"Info" withDelegate:self];
                NSLog(@"Failure");
            });
        }
        
    }];
    [[OTWebServiceHelper sharedInstance] setOnFailure:^(NSError *errorDict){
        
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

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        
        self.twitterTextField= [alertView textFieldAtIndex:0];
        NSLog(@"%@",self.twitterTextField.text);
        [[QPCommonClass initializeUserDefaults]setObject:self.twitterTextField.text forKey:@"TwitterEmailMain"];
        
        if ([self validateDataTwitter]) {
            [self sendDataToServerForTwitter];
            
        }

        
    }
    else if (alertView.tag == 2)
    {
        
    }
    else if (alertView.tag == 3)
    {
        
    }
    
}

#pragma mark - Text Fields Validation

- (BOOL)validateDataTwitter{

    BOOL isValid = YES;
    if ([self.twitterTextField.text empty]){
        isValid = NO;
        UIAlertView *emailAlert2 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Please provide email address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.twitterTextField becomeFirstResponder];
        emailAlert2.tag = 2;
        [emailAlert2 show];
    }
    else if (![self.twitterTextField.text validEmail] ) {
        isValid = NO;
        UIAlertView *emailAlert3 = [[UIAlertView alloc]initWithTitle:AppTitle message:@"Invalid Email" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [self.twitterTextField becomeFirstResponder];
        emailAlert3.tag = 3;
        [emailAlert3 show];
    }
return isValid;
}

@end
