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
@interface ViewController ()
@property (nonatomic, assign) BOOL apiCallComplete;
@property (weak, nonatomic) IBOutlet UIButton *RequestAPIButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITextField *quantityField;
@end

@implementation ViewController

- (void)viewDidLoad {
    self.title = @"搜尋輸入頁";
    [super viewDidLoad];
}

- (IBAction)clickButton:(UIButton *)sender {
    NSDictionary *parameters = @{@"per_page":self.quantityField.text,@"text":self.searchField.text};
    [[DownloadManager sharedInstance]getFlickrDataWith:parameters];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
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
@end