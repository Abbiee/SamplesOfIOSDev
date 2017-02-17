//
//  QPCommonClass.h
//  Que Pics
//
//  Created by Apple on 08/10/15.
//  Copyright © 2015 AppZoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QPCommonClass : NSObject
+ (BOOL)isEmptyString:(NSString *)text;
+ (UIAlertView *)showApplicationAlert:(NSString *)message andTitle:(NSString*)title withDelegate:(id)delegate;
+ (UIAlertView *)showApplicationAlertWithCancelButton:(NSString *)message andTitle:(NSString*)title andTag:(NSInteger)tag withDelegate:(id)delegate;
+(BOOL)isInternetAvailable;
+(void)disableUI;
+(void)enableUI;
+ (NSString *)trimWhiteSpaces:(NSString *)text;
+(NSString*) getDeviceId;
+(UIColor*) setRGBColorRed:(int)red Green:(int)green Blue:(int)blue Alpha:(float)alpha;
+(NSString*) cropImageWithWidth:(int)width andHeight:(int)height;
+(NSUserDefaults*) initializeUserDefaults;
@end



