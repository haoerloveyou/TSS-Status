//
//  ViewController.m
//  TSS-Signing
//
//  Created by cole cabral on 2018-06-13.
//  Copyright © 2018 cole cabral. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *firmwareArray;
    NSMutableArray *nameArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)fetchFirmware {
    NSURL *url = [NSURL URLWithString:@"https://api.ipsw.me/v2.1/firmwares.json/condensed"];
    NSData *response = [NSData dataWithContentsOfURL:url];
    if (response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:nil];
        firmwareArray = [NSMutableArray array];
        nameArray = [NSMutableArray array];
        NSArray *devices = [[dict objectForKey:@"devices"] allKeys];
        NSArray *sorted = [devices sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        for (NSString *device in sorted) {
            NSArray *firmware = [[[dict objectForKey:@"devices"] objectForKey:device] objectForKey:@"firmwares"];
            NSArray *name = [[dict objectForKey:@"devices"] objectForKey:device];
            for (id firm in firmware) {
                BOOL signedStatus = [[firm objectForKey:@"signed"] boolValue];
                if (signedStatus != 0) {
                    [firmwareArray addObject:firm];
                    [nameArray addObject:name];
                    [self.tableView reloadData];
                }
            }
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchFirmware];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)backgroundUpdate:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self fetchFirmware];
    completionHandler(UIBackgroundFetchResultNewData);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [firmwareArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"tss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSDictionary *firmware = [firmwareArray objectAtIndex:indexPath.row];
    NSDictionary *names = [nameArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)", [names objectForKey:@"name"], [firmware objectForKey:@"version"], [firmware objectForKey:@"buildid"]];
    return cell;
}
@end
