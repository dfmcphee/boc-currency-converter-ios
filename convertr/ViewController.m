//
//  ViewController.m
//  convertr
//
//  Created by Dominic McPhee on 2012-11-02.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize rates;
@synthesize amount;
@synthesize to;
@synthesize from;
@synthesize answer;

- (IBAction)convert:(id)sender {
    double value = [amount.text doubleValue];
    
    NSInteger selectedFrom = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom;
    NSInteger selectedTo = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedTo;
    
    double fromRate = [[[self.rates objectAtIndex:(selectedFrom)] objectForKey:@"rate"] doubleValue];
    double toRate = [[[self.rates objectAtIndex:(selectedTo)] objectForKey:@"rate"] doubleValue];
    
    double exchangeRate = fromRate / toRate;
    
    value = value * exchangeRate;
    
    answer.text = [NSString localizedStringWithFormat:@"$%.02f", value];
}

-(IBAction)amountReturn:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)backgroundTouched:(id)sender
{
    [amount resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Dismiss keyboard on background touch
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(backgroundTouched:)];
    
    [self.view addGestureRecognizer:tap];
    
    // Create loading view
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        // Get rates from json service
        NSError *error = nil;
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://exchng.ca/rates"]];
        
        if (jsonData) {
            
            NSArray *feed_object = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:kNilOptions
                                                                     error:&error];
            if (error) {
                NSLog(@"error is %@", [error localizedDescription]);
                
                // Handle Error and return
                return;
            }
            
            self.rates = feed_object;
            
            // Setup delegate data
            AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
            delegate.rates = feed_object;
            delegate.selectedFrom = 0;
            delegate.selectedTo = 1;
            
        } else {
            // Handle Error
        }

        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
