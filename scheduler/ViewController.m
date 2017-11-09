//
//  ViewController.m
//  scheduler
//
//  Created by yaseen on 11/9/17.
//  Copyright © 2017 yaseen. All rights reserved.
//

#import "ViewController.h"
#import "WebService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dismissKeyboard {
    [self.textArea resignFirstResponder];
}

- (IBAction)buttonTapped:(id)sender {
    if (self.textArea.text.length > 0){
        WebService* webservice = [[WebService alloc]init];
        NSDictionary* dict = @{
                               @"message" : self.textArea.text,
                               @"date" : [Helper myDateToFormat: self.datePicker.date  withFormat:@"yyyy-MM-dd HH:mm:ss"]
                               };
        [webservice createMessage:dict callback:^(NSDictionary *result) {
            if ([webservice checkApiResult:result]){
                NSLog(@"HERE");
            }
        }];
    }
}
@end
