//
//  ViewController.m
//  downloadImage
//
//  Created by YEN HUNG I on 2019/7/25.
//  Copyright © 2019 YEN HUNG I. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"
#import "DownloadManager.h"
@interface ViewController ()<UITextFieldDelegate>
@property (nonatomic, assign) BOOL apiCallComplete;
@property (weak, nonatomic) IBOutlet UIButton *RequestAPIButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextField *quantityField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜尋輸入頁";
    self.searchField.delegate = self;
    self.self.searchField.delegate =  self;
}

- (IBAction)clickButton:(UIButton *)sender {
    NSDictionary *parameters = @{@"per_page":self.quantityField.text,@"text":self.searchField.text};
    [[DownloadManager sharedInstance]getFlickrDataWith:parameters];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *destination = segue.destinationViewController;
    destination.title = [[NSString alloc] initWithFormat:@"搜尋結果 %@",self.searchField.text];
}
- (IBAction)inputSearch:(UITextField *)sender {
    //添加文字參數檢查
}

- (IBAction)inputQuantity:(UITextField *)sender {
    //添加數量參數檢查
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if([self.searchField.text isEqualToString:@""]||[self.quantityField.text isEqualToString:@""])return;
    self.RequestAPIButton.enabled = YES;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
@end
