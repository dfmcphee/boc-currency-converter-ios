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
        
        NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://exchng.ca/rates"]];
        
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
            
            dataLoaded = true;
            
            // Setup delegate data
            AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
            delegate.rates = sorted;
            
            [self convert:self];
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
    //Íhud.delegate = self;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"ERROR", nil);;
    [hud showWhileExecuting:@selector(waitForConnection)
                   onTarget:self withObject:nil animated:YES];
}

- (void)waitForConnection {
    while(!dataLoaded) {
        
    }
}

- (void)checkConnectivity {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"exchng.ca"];
    
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

- (IBAction)convert:(id)sender {
    NSInteger selectedFrom = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedFrom;
    NSInteger selectedTo = ((AppDelegate *)[UIApplication sharedApplication].delegate).selectedTo;
    
    double fromRate = [[[self.rates objectAtIndex:(selectedFrom)] objectForKey:@"rate"] doubleValue];
    double toRate = [[[self.rates objectAtIndex:(selectedTo)] objectForKey:@"rate"] doubleValue];
    
    double exchangeRate = fromRate / toRate;
    
    double exchanged = value * exchangeRate;
    
    answer.text = [NSString localizedStringWithFormat:@"%.02f", exchanged];
    
    amount.backgroundColor = [UIColor whiteColor];
}

- (IBAction)refreshButton:(id)sender {
    [self checkConnectivity];
    
    [self convert:self];
}

- (IBAction)swapCurrencies:(id)sender {
    
    AppDelegate *delegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    
    NSInteger selectedFrom = delegate.selectedFrom;
    NSInteger selectedTo = delegate.selectedTo;
    
    delegate.selectedTo = selectedFrom;
    delegate.selectedFrom = selectedTo;
    
    //ConverterViewController *parent = (ConverterViewController*)[self presentingViewController];
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];

    if ([language isEqualToString:@"fr"]) {
        self.from.text = [[self.rates objectAtIndex:selectedTo] objectForKey:@"labelFR"];
        self.to.text = [[self.rates objectAtIndex:selectedFrom] objectForKey:@"labelFR"];
    }
    else {
        self.from.text = [[self.rates objectAtIndex:selectedTo] objectForKey:@"label"];
        self.to.text = [[self.rates objectAtIndex:selectedFrom] objectForKey:@"label"];
    }
    
    NSString *fromShortcode = [[self.rates objectAtIndex:selectedTo] objectForKey:@"shortcode"];
    NSString *toShortcode = [[self.rates objectAtIndex:selectedFrom] objectForKey:@"shortcode"];

    
    self.fromFlag.image = [UIImage imageNamed:[@[fromShortcode, @".png"] componentsJoinedByString:@""]];
    self.toFlag.image = [UIImage imageNamed:[@[toShortcode, @".png"] componentsJoinedByString:@""]];
    
    [self convert:self];
}

-(IBAction)amountReturn:(id)sender {
    [sender resignFirstResponder];
}

-(IBAction)backgroundTouched:(id)sender {
    if (dataLoaded) {
        [amount resignFirstResponder];
        amount.backgroundColor = [UIColor whiteColor];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *newNumber = [formatter numberFromString:amount.text];
        value = [newNumber doubleValue];
        amount.text = [NSString localizedStringWithFormat:@"%.02f", value];
        [self convert:sender];
    }
}

-(IBAction)startEditing:(id)sender {
    amount.backgroundColor = editingColour;
    
}

-(IBAction)finishedEditing:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *newNumber = [formatter numberFromString:amount.text];
    value = [newNumber doubleValue];
    amount.text = [NSString localizedStringWithFormat:@"%.02f", value];
    [self convert:self];
}

// Buttons for custom iPad keyboard

-(IBAction)pressDecimalButton:(id)sender {
    if ([amount.text rangeOfString:@"."].location == NSNotFound) {
        amount.text = [@[amount.text, @"."] componentsJoinedByString:@""];
        value = [amount.text doubleValue];
        amount.backgroundColor = editingColour;
    }
}

-(IBAction)pressCommaButton:(id)sender {
    if ([amount.text rangeOfString:@","].location == NSNotFound) {
        amount.text = [@[amount.text, @","] componentsJoinedByString:@""];
        value = [amount.text doubleValue];
        amount.backgroundColor = editingColour;
    }
}

-(IBAction)pressBackspaceButton:(id)sender {
    if ([amount.text length] > 0) {
        amount.text = [amount.text substringToIndex:[amount.text length]-1];
        value = [amount.text doubleValue];
    }
    amount.backgroundColor = editingColour;
}

-(IBAction)pressClearButton:(id)sender {
    amount.text = @"";
    value = 0;
    amount.backgroundColor = editingColour;
}

-(IBAction)pressNumberButton:(UIButton*)sender {
    amount.text = [@[amount.text, sender.titleLabel.text] componentsJoinedByString:@""];
    value = [amount.text doubleValue];
    amount.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
}

-(IBAction)pressConvertButton:(id)sender {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *newNumber = [formatter numberFromString:amount.text];
    value = [newNumber doubleValue];
    amount.text = [NSString localizedStringWithFormat:@"%.02f", value];
    [self convert:self];
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
    
    editingColour = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.0];
    
    value = 1.0;
    
    amount.text = [NSString localizedStringWithFormat:@"%.02f", value];
    
    [self checkConnectivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
