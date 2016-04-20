//
//  ViewController.m
//  手势解锁
//
//  Created by MXQ on 16/4/20.
//  Copyright © 2016年 MXQ. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet LockView *lockView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   [self.lockView setPassWordBlock:^(NSInteger pwd) {
       if (pwd == 10) {
           self.label.text = @"";
           return ;
       }
       self.label.text = [self.label.text stringByAppendingString:[NSString stringWithFormat:@"%zd",pwd]];
   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
