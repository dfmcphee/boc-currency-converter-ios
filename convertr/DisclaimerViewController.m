//
//  DisclaimerViewController.m
//  Exchng
//
//  Created by Dominic McPhee on 2014-06-05.
//  Copyright (c) 2014 2pages. All rights reserved.
//

#import "DisclaimerViewController.h"

@interface DisclaimerViewController ()

@end

@implementation DisclaimerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc]
                                                 initWithTarget:self action:@selector(userSwiped:)];
    
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:downRecognizer];
    
    UIScreenEdgePanGestureRecognizer *swipeRight = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(userSwiped:)];
    
    [swipeRight setEdges:UIRectEdgeLeft];
    
    [self.view addGestureRecognizer:swipeRight];
}

//Action method
- (void)userSwiped:(UIGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
