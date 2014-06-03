//
//  FTINPatientTableViewSource.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTINPatientController.h"

@class FTINPatientTableViewSource, Patient;

@protocol FTINPatientTableViewSourceDelegate <NSObject>

- (void)patientTableViewSource:(FTINPatientTableViewSource *)source selectedPatient:(Patient *)patient;

- (void)patientTableViewSource:(FTINPatientTableViewSource *)source deletedPatient:(Patient *)patient;

@end

@interface FTINPatientTableViewSource : NSObject <UITableViewDelegate, UITableViewDataSource, FTINPatientControllerDelegate>

@property (nonatomic, weak) UITableView *parentTableView;
@property (nonatomic, weak) id<FTINPatientTableViewSourceDelegate> delegate;

- (id)initWithTableView:(UITableView *)tableView andDelegate:(id<FTINPatientTableViewSourceDelegate>)delegate;

- (void)update;

- (void)getPatientsWithSearchTerm:(NSString *)searchTerm;

@end
