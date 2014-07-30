//
//  PurchaseItems.m
//  phonetag
//
//  Created by Brandon Phillips on 6/5/14.
//  Copyright (c) 2014 Operation CMYK. All rights reserved.
//

#import "PurchaseItems.h"


@interface PurchaseItems ()

@end

@implementation PurchaseItems

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"loading");
        appDel = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
    }
    return self;
}


-(void)buyItem:(NSString *)itemId dbId:(NSString *)dbId itemQ:(NSString *)quantity user:(NSString *)uid
{
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
    if ([SKPaymentQueue canMakePayments])
    {
        
        self.userId = uid;
        self.productID = itemId;
        self.databaseId = dbId;
        self.itemQuantity = quantity;
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:
                                      [NSSet setWithObject:self.productID]];
        request.delegate = self;
        
        [request start];
    }
    else
        _productDescription.text =
        @"Please enable In App Purchase in Settings";
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads;
{
    for (SKDownload *download in downloads) {
        
        if (download.downloadState == SKDownloadStateFinished) {
            NSLog(@"download finished: %ld", (long)download.downloadState);
            [queue finishTransaction:download.transaction];
            
        } else if (download.downloadState == SKDownloadStateActive) {
            NSLog(@"download active: %ld", (long)download.downloadState);
            
        } else {
            NSLog(@"Warn: not handled: %ld", (long)download.downloadState);
        }
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"transactions: %@", transaction);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"PURCHASED %@", transaction.transactionIdentifier);
                    [self addItemToUser: transaction.transactionIdentifier trans:transaction];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction Failed");
                if (transaction.downloads) {
                    NSLog(@"has downloads");
                    [[SKPaymentQueue defaultQueue]
                     finishTransaction:transaction];
                }
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                NSLog(@"RESTORED");
                [self addItemToUser: transaction.transactionIdentifier trans:transaction];
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            default:
                break;
            
        }
        
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSArray *products = response.products;
    NSLog(@"products: %@", products);
    for (SKProduct *prod in products){
        NSLog(@"product title: %@",prod.productIdentifier);
    }
    
    if (products.count != 0)
    {
        _product = products[0];
        _buyButton.enabled = YES;
        _productTitle.text = _product.localizedTitle;
        _productDescription.text = _product.localizedDescription;
        SKPayment *payment = [SKPayment paymentWithProduct:_product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    } else {
        _productTitle.text = @"Product not found";
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
        NSLog(@"Product not found: %@", product);
    }
}

- (void)addItemToUser: (NSString *)transactionID trans: (SKPaymentTransaction *)transaction{
    
    NSString *quantity = [[NSString alloc]init];
    for (NSDictionary *pItem in mainArsenalArray){
        if ([[pItem objectForKey:@"appleId"] isEqualToString:transactionID]){
            quantity = [pItem objectForKey:@"quantity"];
        }
    }
    NSString *post = [NSString stringWithFormat: @"user=%@&item=%@&quantity=%@", staticUserInfo.ptId, transactionID, quantity];
    NSLog(@"post: %@", post);
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSString *fullURL = @"http://www.operationcmyk.com/phonetag/phoneTag.php?fn=additems";
    
    NSMutableURLRequest *addItemRequest = [[NSMutableURLRequest alloc] init];
    [addItemRequest setURL:[NSURL URLWithString:fullURL]];
    [addItemRequest setHTTPMethod:@"POST"];
    [addItemRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [addItemRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [addItemRequest setHTTPBody:postData];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *addItemSession = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];
    NSURLSessionDataTask *addItemTask = [addItemSession dataTaskWithRequest:addItemRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSString *datastring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"finished with number: %@", datastring);
            if ([datastring isEqualToString:@"1"]){
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"purchaseditem" object:self];
                
            }
        });
    }];
    
    [addItemTask resume];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PTStaticInfo sharedManager];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
