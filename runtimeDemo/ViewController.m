//
//  ViewController.m
//  runtimeDemo
//
//  Created by XuHuan on 16/3/3.
//  Copyright © 2016年 XuHuan. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/runtime.h>

@interface ViewController ()

@property (nonatomic, strong) Person *tom;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(secondVCMethod)];
    self.tom = [[Person alloc] init];
    self.tom.name = @"tome";
    self.tom.age = @"15";
    self.tom.sex = @"man";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    Class class = NSClassFromString(@"SecondViewController");
    UIViewController *vc = class.new;
    if (aSelector ==  NSSelectorFromString(@"secondVCMethod")) {
        return vc;
    }
    return nil;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    return [super resolveInstanceMethod:sel];
}

- (IBAction)show:(id)sender {
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self.tom class], &count);
    for (int i = 0 ; i < count ; i++) {
        Ivar var = ivar[i];
        const char *varName = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:varName];
        if ([name isEqualToString:@"_name"]) {
            object_setIvar(self.tom, var, @"jace");
            break;
        }
    }
    NSLog(@"%@",self.tom.name);
}






@end
