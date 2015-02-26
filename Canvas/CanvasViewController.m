//
//  CanvasViewController.m
//  Canvas
//
//  Created by AP Fritts on 2/25/15.
//  Copyright (c) 2015 AP Fritts. All rights reserved.
//

#import "CanvasViewController.h"

@interface CanvasViewController ()

@property (weak, nonatomic) IBOutlet UIView *trayView;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;
@property (assign, nonatomic) CGPoint trayOriginalCenter;
@property (assign, nonatomic) CGPoint openPosition;
@property (assign, nonatomic) CGPoint closePosition;
@property (strong, nonatomic) UIImageView *newlyCreatedFace;
@property (assign, nonatomic) CGPoint faceOriginalCenter;

@end

@implementation CanvasViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.openPosition = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height - [self.trayView bounds].size.height);
    self.closePosition = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height - 25);
}

- (IBAction)onTrayPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [self.panGestureRecognizer locationInView:self.view];
    CGPoint translation = [self.panGestureRecognizer translationInView:self.view];
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
    
    if (self.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Gesture began at point: %f, %f - velocity %f", location.x, location.y, velocity.y);
        self.trayOriginalCenter = self.trayView.center;
        
    } else if (self.panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed with point: %f, %f - velocity %f", location.x, location.y, velocity.y);
        self.trayView.center = CGPointMake(self.trayOriginalCenter.x, self.trayOriginalCenter.y + translation.y);
        
    } else if (self.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at point: %f, %f - velocity %f", location.x, location.y, velocity.y);
        
        if (velocity.y > 0) {
            // moving down
            [UIView animateWithDuration:0.3 animations:^{
                self.trayView.frame = CGRectMake(self.closePosition.x, self.closePosition.y, self.trayView.frame.size.width, self.trayView.frame.size.height);
            }];
        } else if (velocity.y < 0) {
            // moving up
            [UIView animateWithDuration:0.3 animations:^{
                self.trayView.frame = CGRectMake(self.openPosition.x, self.openPosition.y, self.trayView.frame.size.width, self.trayView.frame.size.height);
            }];
        }
    }
    
    
}

#pragma mark Face Pan Gesture Recognizer Actions

- (IBAction)onFacePan:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    CGPoint translation = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    

    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Image %@ began at point: %f, %f - velocity %f", sender, location.x, location.y, velocity.y);

        UIImageView *imageView = (UIImageView *)sender.view;
        self.newlyCreatedFace = [[UIImageView alloc] initWithImage:imageView.image];
        
        self.newlyCreatedFace.center = CGPointMake(imageView.center.x, self.trayView.frame.origin.y + imageView.center.y);
        self.faceOriginalCenter = self.newlyCreatedFace.center;
        
        [self.view addSubview:self.newlyCreatedFace];
        
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        NSLog(@"Gesture changed with point: %f, %f - velocity %f", location.x, location.y, velocity.y);
        
        self.newlyCreatedFace.center = CGPointMake(self.faceOriginalCenter.x + translation.x, self.faceOriginalCenter.y + translation.y);
        
//        NSLog(@"Image position: %f, %f", self.newlyCreatedFace)
        
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        NSLog(@"Gesture ended at point: %f, %f - velocity %f", location.x, location.y, velocity.y);

        }
}


@end
