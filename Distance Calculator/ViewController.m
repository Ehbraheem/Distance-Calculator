//
//  ViewController.m
//  Distance Calculator
//
//  Created by AppsWorkforce 2 on 30/03/2017.
//  Copyright © 2017 Ehbraheem. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *request;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;

@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;

@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;

@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@end

@implementation ViewController

- (IBAction)calculateButtonTapped:(id)sender {
    
    self.calculateButton.enabled = NO;
    
    self.request = [DGDistanceRequest alloc];
    
    NSString *start = self.startLocation.text;
    
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    
    NSArray *dests = @[destA, destB, destC];
    
    self.request = [self.request initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    void (^displayBlock) (id, NSUInteger, BOOL *);
    
    NSDictionary *viewMap = @{ @"0" : weakSelf.distanceA, @"1" : weakSelf.distanceB, @"2" : weakSelf.distanceC };
    
//    NSDictionary *viewMap = @{ @0 : self.distanceA, @1 : self.distanceB, @2 : self.distanceC };
    
    displayBlock = ^(id object, NSUInteger index, BOOL *stop) {
        
        NSNull *badResult = [NSNull null];
        ViewController *strongSelf = weakSelf;
        double num;
        NSString *result;
        
        NSString *currentIndex = [NSString stringWithFormat:@"%lu",(unsigned long) index];
        
        UILabel *currentView =  [viewMap objectForKey:currentIndex];
        
        if (object != badResult) {
            if (strongSelf.unitController.selectedSegmentIndex == 0) {
                num = ([object doubleValue] /1.0) ;
                result = [NSString stringWithFormat:@"%.2f meters", num];
            }
            else if (strongSelf.unitController.selectedSegmentIndex == 1) {
                num =  ([object doubleValue] /1000.0);
                result = [NSString stringWithFormat:@"%.2f km", num];
            }
            else {
                num = ([object doubleValue] * 0.000621371 ) ;
                result = [NSString stringWithFormat:@"%.2f miles", num];
            }
            
            currentView.text = result;
            NSLog(@"THE VIEW = %@", currentView);
            NSLog(@"%@", result);
            
        }
        else {
            currentView.text = @"Error";
        }
    };
    
    
   self.request.callback = ^(NSArray *responses) {
       
       ViewController *strongSelf = weakSelf;
       if (!strongSelf) return;
       
       [responses enumerateObjectsUsingBlock: displayBlock];
        
//       NSNull *badResult = [NSNull null];
//       
//       
//       double num;
//       NSString *result;
//       
//       if (responses[0] != badResult) {
//           if (strongSelf.unitController.selectedSegmentIndex == 0) {
//               num = ([responses[0] doubleValue] /1.0) ;
//               result = [NSString stringWithFormat:@"%.2f meters", num];
//           }
//           else if (strongSelf.unitController.selectedSegmentIndex == 1) {
//               num =  ([responses[0] doubleValue] /1000.0);
//               result = [NSString stringWithFormat:@"%.2f km", num];
//           }
//           else {
//               num = ([responses[0] doubleValue] * 0.000621371 ) ;
//               result = [NSString stringWithFormat:@"%.2f miles", num];
//           }
//           
//           strongSelf.distanceA.text = result;
//       }
//       else {
//           strongSelf.distanceA.text = @"Error";
//       }
       
       strongSelf.request = nil;
       strongSelf.calculateButton.enabled = YES;
       
    };
    
    [self.request start];
    
}


@end
