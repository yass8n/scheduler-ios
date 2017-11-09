//
//  ViewController.m
//  scheduler
//
//  Created by yaseen on 11/9/17.
//  Copyright © 2017 yaseen. All rights reserved.
//

#import "ViewController.h"
#import "WebService.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIView *overlay;
@property (strong, nonatomic) NSMutableArray* tableViewData;
@end

@implementation ViewController

#define password @"yaseenme"

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initGesturesAndListeners];
    [self initViews];
    [self presentPasswordPrompt];
    [self getAllMessages];
}

- (void) viewWillAppear:(BOOL)animated{
    [self registerNotifs];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark register notifs
-(void)registerNotifs{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentPasswordPrompt)
                                                 name:@"ApplicationDidBecomeActive"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(presentOverlay)
                                                 name:@"ApplicationWillResignActive"
                                               object:nil];
}

#pragma mark init

- (void) initGesturesAndListeners {
    [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void) initViews {
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.textArea.layer.borderWidth = 1.0f;
    self.textArea.layer.cornerRadius = 3;
    self.textArea.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void) presentOverlay {
    if (self.overlay != nil) {
        [self.overlay removeFromSuperview];
    }
    self.overlay = [[UIView alloc] initWithFrame:self.view.frame];
    self.overlay.userInteractionEnabled = YES;
    [self.overlay setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.overlay];
}
- (void) presentPasswordPrompt {
    [self presentOverlay];
    __block UITextField *myTextField;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Message" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Check" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([myTextField.text isEqualToString:password]){
            [self.overlay removeFromSuperview];
        }
    }]];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Enter text:";
        myTextField = textField;
    }];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) getAllMessages {
    WebService* webservice = [[WebService alloc]init];
    [webservice fetchMessages:^(NSDictionary *result) {
        if ([webservice checkApiResult:result]){
            self.tableViewData = [result valueForKeyPath:@"data.texts"];
            NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"send_at" ascending:YES];
            self.tableViewData = [[self.tableViewData sortedArrayUsingDescriptors:@[descriptor]] mutableCopy];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark actions

- (void)dismissKeyboard {
    [self.textArea resignFirstResponder];
}

- (void)dateIsChanged:(id)sender{
//    [self dismissKeyboard];
}

- (IBAction)sendButtonTapped:(id)sender {
    if (self.textArea.text.length > 0){
        WebService* webservice = [[WebService alloc]init];
        NSDictionary* dict = @{
                               @"message" : self.textArea.text,
                               @"date" : [Helper myDateToFormat: self.datePicker.date  withFormat:@"yyyy-MM-dd HH:mm:ss"]
                               };
        [webservice createMessage:dict callback:^(NSDictionary *result) {
            if ([webservice checkApiResult:result]){
                [self.textArea setText:@""];
            }
        }];
    }
}

- (IBAction)refreshButtonTapped:(id)sender {
    [self getAllMessages];
    [self dismissKeyboard];
}

- (IBAction)clearButtonTapped:(id)sender {
    
        NSString * title = @"Are you sure?";
        UIAlertController* alert = [UIAlertController
                                    alertControllerWithTitle:title
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* button0 = [UIAlertAction
                                  actionWithTitle:@"Yes, Clear it"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action)
                                  {
                                      WebService* webservice = [[WebService alloc]init];
                                      [webservice clearMessages:^(NSDictionary *result) {
                                          if ([webservice checkApiResult:result]){
                                              [self getAllMessages];
                                          }
                                      }];
                                      
                                  }];
        
        UIAlertAction* button1 = [UIAlertAction
                                  actionWithTitle:@"Cancel"
                                  style:UIAlertActionStyleCancel
                                  handler:^(UIAlertAction * action)
                                  {
                                      
                                      
                                  }];
        
        
        
        [alert addAction:button0];
        [alert addAction:button1];
        [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
    }
    NSDictionary *item = (NSDictionary *)[self.tableViewData objectAtIndex:indexPath.row];
    cell.textLabel.text = [item objectForKey:@"message"];
    cell.detailTextLabel.text = [Helper stringFromDate:[Helper UTCtoNSDate:[item objectForKey:@"send_at"]] withFormat:@"EE, d LLLL hh:mm a"];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = (NSDictionary *)[self.tableViewData objectAtIndex:indexPath.row];
    
    NSString * title = [NSString stringWithFormat:@"Delete '%@'?", [item objectForKey:@"message"]];;
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:title
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Yes, delete it"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  WebService* webservice = [[WebService alloc]init];
                                  NSDictionary * dict = @{@"id" : [item objectForKey:@"id"]};
                                  [webservice deleteMessage:dict callback:^(NSDictionary *result) {
                                      if ([webservice checkApiResult:result]){
                                          [self getAllMessages];
                                      }
                                      [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                  }];
                                  
                              }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  [tableView deselectRowAtIndexPath:indexPath animated:NO];
                                  
                              }];
    
    
    
    [alert addAction:button0];
    [alert addAction:button1];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self dismissKeyboard];
}


@end
