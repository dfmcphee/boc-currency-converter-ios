//
//  ConverterViewController.h
//  convertr
//
//  Created by Dominic McPhee on 2012-11-02.
//  Copyright (c) 2012 2pages. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConverterViewController.h"

@interface ConverterViewController : UIViewController {
    UIActionSheet *fromSheet;
    UIActionSheet *toSheet;
    
    NSArray *rates;
    double value;
    
    IBOutlet UITextField *amount;
    IBOutlet UILabel *from;
    IBOutlet UIImageView *fromFlag;
    IBOutlet UILabel *to;
    IBOutlet UIImageView *toFlag;
    IBOutlet UILabel *answer;
    UIView *accessoryView;
    UIButton *btnDone;
    UIAlertView *alert;
}

@property (retain, nonatomic) IBOutlet UITextField *amount;
@property (retain, nonatomic) IBOutlet UILabel *from;
@property (retain, nonatomic) IBOutlet UIImageView *fromFlag;
@property (retain, nonatomic) IBOutlet UILabel *to;
@property (retain, nonatomic) IBOutlet UIImageView *toFlag;
@property (retain, nonatomic) IBOutlet UILabel *answer;
@property (retain, nonatomic) IBOutlet NSArray *rates;
@property (nonatomic, strong) IBOutlet UIView *accessoryView;
@property (nonatomic, retain) UIButton *btnDone;

- (IBAction)convert:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

- (IBAction)finishedEditing:(id)sender;

- (void)loadRates;

- (void)showAlert;

@end