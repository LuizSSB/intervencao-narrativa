//
//  FTINMasterViewController.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/05/28.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTINPatientTableViewSource.h"

@interface FTINPatientsTableViewController : UITableViewController <FTINPatientTableViewSourceDelegate, UISearchDisplayDelegate>

@end
