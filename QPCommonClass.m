//
//  QPCommonClass.m
//  Que Pics
//
//  Created by Apple on 08/10/15.
//  Copyright © 2015 AppZoc. All rights reserved.
//

#import "QPCommonClass.h"
#import "Reachability.h"

@implementation QPCommonClass

+ (BOOL)isEmptyString:(NSString *)text
{
    return (nil == text ||
            YES == [[self trimWhiteSpaces:text] isEqualToString:@""]) ? YES : NO;
}
+ (NSString *)trimWhiteSpaces:(NSString *)text
{
    return [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+ (UIAlertView *)showApplicationAlert:(NSString *)message andTitle:(NSString*)title withDelegate:(id)delegate
{
    UIAlertView *baseAlert = nil;
    if (NO == [self isEmptyString:message])
    {
        baseAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:delegate
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"OK", nil];
        baseAlert.tag = 7884;
        [baseAlert show];
    }
    return baseAlert;
}
+ (UIAlertView *)showApplicationAlertWithCancelButton:(NSString *)message andTitle:(NSString*)title andTag:(NSInteger)tag withDelegate:(id)delegate
{
    UIAlertView *baseAlert = nil;
    if (NO == [self isEmptyString:message])
    {
        baseAlert = [[UIAlertView alloc] initWithTitle:title
                                               message:message
                                              delegate:delegate
                                     cancelButtonTitle:@"OK"
                                     otherButtonTitles:@"Cancel", nil];
        baseAlert.tag = tag;
        [baseAlert show];
    }
    return baseAlert;
}
+(BOOL)isInternetAvailable
{
    Reachability  *internetConnectionReach = [Reachability reachabilityForInternetConnection];
    
    if([internetConnectionReach isReachable]&&[internetConnectionReach currentReachabilityStatus])
        return YES;
    else
        return NO;
}
+(UIColor*) setRGBColorRed:(int)red Green:(int)green Blue:(int)blue Alpha:(float)alpha
{
    return [UIColor colorWithRed:(red/255) green:(green/255) blue:(blue/255) alpha:alpha];
}
+(void)disableUI
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

+(void)enableUI
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}
+(NSString*) getDeviceId{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}
+(NSUserDefaults*) initializeUserDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

+(NSString*) cropImageWithWidth:(int)width andHeight:(int)height{
    return [NSString stringWithFormat:@"/thumb/f/%d/%d",width,height];
}

@end


