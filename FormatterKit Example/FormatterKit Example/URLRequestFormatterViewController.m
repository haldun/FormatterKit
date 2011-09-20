// URLRequestFormatterViewController.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "URLRequestFormatterViewController.h"

#import "TTTURLRequestFormatter.h"

enum {
    StandardSectionIndex,
    cURLSectionIndex,
    WgetSectionIndex,
} URLRequestFormatterViewControllerSectionIndexes;

@interface URLRequestFormatterViewController ()
@property (readwrite, nonatomic, retain) NSURLRequest *request;
@end

@implementation URLRequestFormatterViewController
@synthesize request = _request;

- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (!self) {
        return nil;
    }
    
    self.title = NSLocalizedString(@"Hours of Operation Formatter", nil);
    
    NSMutableURLRequest *mutableRequest = [[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://api.gowalla.com/spots"]] autorelease];
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    self.request = mutableRequest;
    
    return self;
}

+ (NSString *)formatterDescription {
    return NSLocalizedString(@"TTTURLRequestFormatter formats NSURLRequests, and generates cURL and Wget commands with all of its headers and data fields intact to debug in the console.", nil);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case cURLSectionIndex:
            return NSLocalizedString(@"cURL Command", nil);
        case WgetSectionIndex:
            return NSLocalizedString(@"Wget Command", nil);
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *command = nil;
    switch (indexPath.section) {
        case cURLSectionIndex:
            command = [TTTURLRequestFormatter cURLCommandFromURLRequest:self.request];
            break;
        case WgetSectionIndex:
            command = [TTTURLRequestFormatter WgetCommandFromURLRequest:self.request];
            break;
        default:
            return tableView.rowHeight;
    }

    CGSize size = [command sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280.0f, tableView.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
    
    return fmaxf(size.height + 16.0f, self.tableView.rowHeight);
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    
    static TTTURLRequestFormatter *_urlRequestFormatter = nil;
    if (!_urlRequestFormatter) {
        _urlRequestFormatter = [[TTTURLRequestFormatter alloc] init];
    }
    
    switch (indexPath.section) {
        case StandardSectionIndex:
            cell.textLabel.text = [_urlRequestFormatter stringFromURLRequest:self.request];
            break;
        case cURLSectionIndex:
            cell.textLabel.text = [TTTURLRequestFormatter cURLCommandFromURLRequest:self.request];
            break;
        case WgetSectionIndex:
            cell.textLabel.text = [TTTURLRequestFormatter WgetCommandFromURLRequest:self.request];
            break;
    }
}

@end
