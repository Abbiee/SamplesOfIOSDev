#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

typedef void (^OnSuccess) (NSDictionary *responseData);
typedef void (^OnSuccessArray) (NSArray *responseData);
typedef void (^OnFailure) (NSError *error);

@class OTWebServiceHelper;

@protocol OTWebServiceHelperDelegate <NSObject>
//- (void)webserviceHelper:(OTWebServiceHelper *) webserviceHelper     didRecieveData:(NSData*) resultData;
//- (void)webserviceHelper:(OTWebServiceHelper *) webserviceHelper     didFailWithError:(NSError *)error;
@end

@interface OTWebServiceHelper : NSObject<NSURLConnectionDelegate>
{
    
}
@property (nonatomic, strong) NSTimer *recoverRequestTimer;
@property (nonatomic, strong) NSMutableDictionary *requestDataDict;
@property (nonatomic, assign) id <OTWebServiceHelperDelegate>    delegate;
@property (nonatomic, retain) NSMutableData                      *webData;
@property (nonatomic, retain) NSURL                                  *url;
@property (nonatomic, assign) NSInteger                            userID;
@property (nonatomic, strong) NSString*                      deviceTocken;
@property (nonatomic, assign) BOOL                            isFromLogin;
@property (nonatomic, assign) BOOL                             isFromPush;
@property (nonatomic, assign) NSInteger                     newbadgeCount;
@property (nonatomic, assign) NSInteger                   claimbadgeCount;
@property (nonatomic, assign) NSInteger                           alarmID;
@property (nonatomic, assign) BOOL                              isFromNew;
@property (nonatomic, copy) OnSuccess                           onSuccess;
@property (nonatomic, copy) OnSuccessArray                 onSuccessArray;
@property (nonatomic, copy) OnFailure                           OnFailure;
@property (nonatomic, retain)NSURLSession                  *connection;


+ (OTWebServiceHelper *) sharedInstance;
- (void)cleanUpWebServiceRequest;
//- (void) cancelRequest;



-(void) qpPostToServerWithParameters:(NSString *)paramString andApi:(NSString *)apiString;
-(void) getAllCategoryListFromServer:(NSString *)paramString;
-(void) getQuestionsBasedOnPageFromServer:(NSString *)pageId;
-(void)postImage:(UIImage *)image andDetails:(NSDictionary *)params apiUrl:(NSString*)urlName imageKey:(NSString*)imageKey;
-(void)updateProfilepostImage:(UIImage *)image andDetails:(NSDictionary *)params;
-(void)postImage:(UIImage *)image andDetails:(NSDictionary *)params;

-(void) getAllPointsListFromServer;

-(void) getSearchList:(NSString *)paramString;
-(void)updateProfileProfilePasswordWithDetails:(NSDictionary *)params;

@end
