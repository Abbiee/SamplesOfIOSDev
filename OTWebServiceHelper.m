
#import "OTWebServiceHelper.h"
#import "QPGlobal.h"
#import "QPCommonClass.h"

@implementation OTWebServiceHelper

static OTWebServiceHelper *shareService    = nil;
static NSMutableDictionary     *pushInformDic = nil;

+ (OTWebServiceHelper *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == shareService)
        {
            shareService = [[self alloc] init];
            pushInformDic = [[NSMutableDictionary alloc] init];
            [pushInformDic setObject:[NSMutableArray array]   forKey:@"newAlarmArray"];
            [pushInformDic setObject:[NSMutableArray array] forKey:@"claimAlarmArray"];
        }
    }
    return shareService;
}
-(void) qpPostToServerWithParameters:(NSString *)paramString andApi:(NSString *)apiString
{
    if ([QPCommonClass isInternetAvailable]) {
        self.webData = nil;
        NSURL *url = [NSURL URLWithString:apiString];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        
        NSData *postData = [paramString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPBody:postData];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            if (data) {
                [self setResponseDataToDictionary:data];
            }
            else{
                
            }
        }];
        [dataTask resume];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}


-(void)postImage:(UIImage *)image andDetails:(NSDictionary *)params apiUrl:(NSString*)urlName imageKey:(NSString*)imageKey{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *BoundaryConstant = @"********";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    if (image!=nil) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",imageKey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *registerationURL = [NSString stringWithFormat:@"%@%@",BaseURL,urlName];
    NSLog(@"Register %@",registerationURL);
    [request setURL:[NSURL URLWithString:registerationURL]];
    
    NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest: request delegate:self];
    [connection start];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}

-(void) setResponseDataToDictionary :(NSData*)responseData{
    if ([NSJSONSerialization isValidJSONObject:responseData])
    {
        NSLog(@"===>>>Success");
    }
    NSDictionary *jsonDict;
    NSError *error;
    @try {
        jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
     //   NSString *retVal = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
    @finally {
        if (self.onSuccess)
            self.onSuccess(jsonDict);
    }
    
}

-(void) setResponseDataToArray :(NSData*)responseData{
    NSError *error;
    
    NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if (self.onSuccessArray)
        self.onSuccessArray(jsonDict);
}
-(void) getAllPointsListFromServer{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSString *urlString = @"http://que.it/api/manage_points/get_manage_points";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data != nil) {
            [self setResponseDataToDictionary:data];
        }
        
    }];
    [dataTask resume];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}

-(void) getAllCategoryListFromServer:(NSString *)paramString{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSString *urlString = @"http://que.it/api/categories/get_category";
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data != nil) {
            [self setResponseDataToDictionary:data];
        }
        
    }];
    [dataTask resume];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}

-(void) getSearchList:(NSString *)paramString
{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSString *urlString =[NSString stringWithFormat:@"http://que.it/api/questions/searchQuestion/%@/%@",[[QPCommonClass initializeUserDefaults] objectForKey:@"USER_ID"],paramString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data != nil) {
            [self setResponseDataToDictionary:data];
        }
    }];
    [dataTask resume];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}

-(void) getQuestionsBasedOnPageFromServer:(NSString *)pageId{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@/%@",DashBoard,[[QPCommonClass initializeUserDefaults] objectForKey:@"USER_ID"],[[QPCommonClass initializeUserDefaults] objectForKey:[NSString stringWithFormat:@"%@",[[QPCommonClass initializeUserDefaults] objectForKey:@"USER_ID"]]],pageId]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //    NSData *postData = [paramString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setHTTPMethod:@"GET"];
    //    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //    [request setHTTPBody:postData];
    
    //    NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest: request delegate:self];
    //    [connection start];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data != nil) {
            [self setResponseDataToDictionary:data];
        }
        
    }];
    [dataTask resume];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}
-(void)updateProfilepostImage:(UIImage *)image andDetails:(NSDictionary *)params{
    if ([QPCommonClass isInternetAvailable]) {
    self.webData = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *BoundaryConstant = @"********";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    if (image!=nil) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"user_image"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *registerationURL = [NSString stringWithFormat:@"%@%@%@",BaseURL,ProfileUpdateURL,[[QPCommonClass initializeUserDefaults] valueForKey:@"USER_ID"]];
    NSLog(@"Register %@",registerationURL);
    [request setURL:[NSURL URLWithString:registerationURL]];
    
    NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest: request delegate:self];
    [connection start];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}


-(void)updateProfileProfilePasswordWithDetails:(NSDictionary *)params{
    if ([QPCommonClass isInternetAvailable]) {
        self.webData = nil;
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        NSString *BoundaryConstant = @"********";
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        for (NSString *param in [params allKeys]) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // add image data
//        if (image!=nil) {
//            
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
//            if (imageData) {
//                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
//                //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"user_image"] dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//                [body appendData:imageData];
//                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//            }
//            
//        }
        
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        NSString *registerationURL = [NSString stringWithFormat:@"%@%@%@",BaseURL,PasswordUpdateURL,[[QPCommonClass initializeUserDefaults] valueForKey:@"USER_ID"]];
        NSLog(@"Password Update %@",registerationURL);
        [request setURL:[NSURL URLWithString:registerationURL]];
        
        NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest: request delegate:self];
        [connection start];
    }
    else{
        [QPCommonClass showApplicationAlert:@"Please check your network availability. Not able to connect to server" andTitle:@"Info" withDelegate:self];
        [self setResponseDataToDictionary:nil];
    }
}



-(void)cleanUpWebServiceRequest
{
    NSLog(@"cleanUpWebServiceRequest *****************");
    // cancel the connection
    [self.connection invalidateAndCancel];
    self.onSuccess        = nil;
    self.OnFailure        = nil;
    self.connection       = nil;
    self.webData          = nil;
    self.delegate         = nil;
    // set the status as cancelled.
}

#pragma mark -
#pragma mark NSURLConnectionDelegate


/**
 NSURLConnection delegate method
 This method is called to deliver the content of a URL
 load.
 
 @param connection  NSURLConnection that has received data.
 @param data A chunk of URL load data.
 */

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
    }
}



/*!
 @method connection:didReceiveData:
 @abstract This method is called to deliver the content of a URL
 load.
 
 @param connection  NSURLConnection that has received data.
 @param data A chunk of URL load data.
 */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   NSMutableData *localData = [[NSMutableData alloc]initWithData:self.webData];
    [localData appendData:data];
    self.webData = localData;
}

/**
 This method is called when an NSURLConnection has
 failed to load successfully.
 
 @param connection an NSURLConnection that has failed to load.
 @param error The error that encapsulates information about what
 caused the load to fail.
 */
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    // do the clean up
//    [self cleanUpWebServiceRequest];
//    // Inform the caller abt the error
//    if([self.delegate respondsToSelector: @selector(webserviceHelper:didFailWithError:)])
//    {
//        NSError *newError;
//        [self.delegate webserviceHelper:self didFailWithError:newError];
//    }
    
    if (self.OnFailure)
        self.OnFailure(error);
    
    
}

/**
 This method is called when an NSURLConnection has
 finished loading successfully.
 
 @param connection an NSURLConnection that has finished loading
 successfully.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    NSError         *error;
    
    
//    NSDictionary *JSON =
//    [NSJSONSerialization JSONObjectWithData: self.webData
//                                    options: NSJSONReadingMutableContainers
//                                      error: &error];

    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:self.webData options:0 error:&error];

  //  NSString *retVal = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
    
    if (self.onSuccess)
            self.onSuccess(jsonDict);
    
//     {
//        if(self.delegate)
//        {
//            if([self.delegate respondsToSelector: @selector(webserviceHelper:didRecieveData:)])
//            {
//                NSString *retVal = [[NSString alloc] initWithData:self.webData
//                                                         encoding:NSUTF8StringEncoding];
//                NSLog(@"%@", retVal);
//                [self.delegate webserviceHelper:self didRecieveData:self.webData];
//            }
//        }
//        [self cleanUpWebServiceRequest];
//    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults removeObjectForKey:@"stakeHolderElements"];
}

/**
 This method is called whenever an NSURLConnection
 determines that it must change URLs in order to continue loading a
 request.
 
 @param connection an NSURLConnection that has determined that it
 must change URLs in order to continue loading a request.
 @param request The NSURLRequest object that will be used to
 continue loading. The delegate should copy and modify this request
 as necessary to change the attributes of the request, or can
 simply return the given request if the delegate determines that no
 changes need to be made.
 @param redirectResponse The NSURLResponse that caused this
 callback to be sent. This argument is nil in cases where this
 callback is not being sent as a result of involving the delegate
 in redirect processing.
 @result The request that the URL loading system will use to
 continue.
 */
- (NSURLRequest *)connection:(NSURLConnection *)connection
             willSendRequest:(NSURLRequest *)request
            redirectResponse:(NSURLResponse *) redirectResponse
{
    return request;
}

/**
 This method gives the delegate an opportunity to inspect an
 NSURLProtectionSpace before an authentication attempt is made.
 
 @param connection an NSURLConnection that has an NSURLProtectionSpace ready for inspection
 @param protectionSpace an NSURLProtectionSpace that will be used to generate an authentication challenge
 @result a boolean value that indicates the willingness of the delegate to handle the authentication
 */
- (BOOL)connection:(NSURLConnection *)connection
canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

/**
 Start authentication for a given challenge
 
 @param connection the connection for which authentication is needed
 @param challenge The NSURLAuthenticationChallenge to start authentication for
 */
- (void)connection:(NSURLConnection *)connection
didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

-(void)postImage:(UIImage *)image andDetails:(NSDictionary *)params{
    
    self.webData = nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    NSString *BoundaryConstant = @"********";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *param in [params allKeys]) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    // add image data
    if (image!=nil) {
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            //[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", @"user_image"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    NSString *registerationURL = [NSString stringWithFormat:@"%@%@",BaseURL,RegisterURL];
    NSLog(@"Register %@",registerationURL);
    [request setURL:[NSURL URLWithString:registerationURL]];
    
    NSURLConnection *connection =  [[NSURLConnection alloc] initWithRequest: request delegate:self];
    [connection start];
    
}

@end
