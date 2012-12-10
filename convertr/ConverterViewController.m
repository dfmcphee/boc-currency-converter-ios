//
//  ConverterViewController.m
//  convertr
//
//  Created by Dominic McPhee on 2012-11-02.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import "ConverterViewController.h"
#import "AppDelegate.h"
#import "FromTableViewController.h"
#import "MBProgressHUD.h"
#import "Reachability.h"


@interface ConverterViewController ()

@end

@implementation ConverterViewController

@synthesize rates;
@synthesize amount;
@synthesize to;
@synthesize toFlag;
@synthesize from;
@synthesize fromFlag;
@synthesize answer;
@synthesize btnDone;
@synthesize accessoryView;


-(void)loadRates {
    // Create loading view
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        // Get rates from json service
        NSError *error = nil;
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://exchng.jit.su/rates"]];
        
        if (jsonData) {
            
            NSArray *feed_object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
                
                // Handle Error and return
                [self showAlert];
                
                return;
            }
            
            NSArray *arrayToSort = feed_object ;
            NSComparisonResult (^sortBlock)(id, id) = ^(id obj1, id obj2) {
                if ([[obj1 objectForKey:@"order"] integerValue] > [[obj2 objectForKey:@"order"] integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                if ([[obj1 objectForKey:@"order"] integerValue] < [[obj2 objectForKey:@"order"] integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            };
            NSArray *sorted = [arrayToSort sortedArrayUsingComparator:sortBlock];
            
            self.rates = sorted;
            
            // Setup delegate data
            AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
            delegate.rates = sorted;
            
            //[self createAccordionView];
        } else {
            // Handle Error
            [self showAlert];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)showAlert {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self.view addSubview:hud];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"ERROR", nil);;
    [hud showWhileExecuting:@selector(waitForThreeSeconds)
                   onTarget:self withObject:nil animated:YES];
}

- (void)waitForThreeSeconds {
    sleep(3);
}

- (IBAction)convert:(id)sender {
    NSInteger selectedFrom = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom;
    NSInteger selectedTo = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedTo;
    
    double fromRate = [[[self.rates objectAtIndex:(selectedFrom)] objectForKey:@"rate"] doubleValue];
    double toRate = [[[self.rates objectAtIndex:(selectedTo)] objectForKey:@"rate"] doubleValue];
    
    double exchangeRate = fromRate / toRate;
    
    double exchanged = value * exchangeRate;
    
    answer.text = [NSString localizedStringWithFormat:@"%.02f", exchanged];
}

-(IBAction)amountReturn:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)backgroundTouched:(id)sender {
    [amount resignFirstResponder];
}

-(IBAction)finishedEditing:(id)sender {
    value = [amount.text doubleValue];
    NSNumber *num = [NSNumber numberWithDouble:value];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumFractionDigits:2];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:num];
    amount.text = formattedNumberString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    // Dismiss keyboard on background touch
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(backgroundTouched:)];
    
    [self.view addGestureRecognizer:tap];
        
    [[self amount] setInputAccessoryView:[self accessoryView]];
    
    // Setup delegate data
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    delegate.selectedFrom = 0;
    delegate.selectedTo = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"exchng.jit.su"];
    
    // set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        [self loadRates];
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlert];
    };
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
