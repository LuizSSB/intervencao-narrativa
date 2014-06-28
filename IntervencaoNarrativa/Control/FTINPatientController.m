//
//  FTINPatientController.m
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import "FTINPatientController.h"
#import "DCModel.h"
#import "Patient+Complete.h"

@implementation FTINPatientController

#pragma mark - Super methods

#pragma mark - Instance methods

+ (BOOL)isPatientDataValidWithName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)birthdate
{
	return name.length && examiner.length && birthdate;
}

- (instancetype)initWithDelegate:(id<FTINPatientControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)addPatientWithName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)birthdate
{
	if([FTINPatientController isPatientDataValidWithName:name examiner:examiner sex:sex birthdate:birthdate])
	{
		__block Patient *newGuy = [Patient newObject];
		newGuy.name = name;
		newGuy.examiner = examiner;
		newGuy.birthdate = birthdate;
		newGuy.sex = sex;
		newGuy.creationDate = [NSDate date];
		
		[Patient saveObject:newGuy success:^(id items) {
			[self.delegate patientController:self addedPatient:newGuy error:nil];
		} failure:^(NSError *error) {
			[self.delegate patientController:self addedPatient:newGuy error:error];
		}];
	}
	else
	{
		[self.delegate patientController:self addedPatient:nil error:[NSError ftin_createErrorWithCode:FTINErrorCodeInvalidUserSuppliedData]];
	}
	
}

- (void)editPatient:(Patient *)patient withName:(NSString *)name examiner:(NSString *)examiner sex:(FTINSex)sex birthdate:(NSDate *)date
{
	if([FTINPatientController isPatientDataValidWithName:name examiner:examiner sex:sex birthdate:date])
	{
		NSString *originalName = patient.name;
		NSString *originalExaminer = patient.examiner;
		FTINSex originalSex = patient.sex;
		NSDate *originalDate = patient.birthdate;
		
		patient.name = name;
		patient.examiner = examiner;
		patient.sex = sex;
		patient.birthdate = date;
		
		[Patient updateObject:patient success:^(id items) {
			[self.delegate patientController:self editedPatient:patient error:nil];
		} failure:^(NSError *error) {
			patient.name = originalName;
			patient.examiner = originalExaminer;
			patient.sex = originalSex;
			patient.birthdate = originalDate;
			[self.delegate patientController:self editedPatient:patient error:error];
		}];
	}
	else
	{
		[self.delegate patientController:self editedPatient:patient error:[NSError ftin_createErrorWithCode:FTINErrorCodeInvalidUserSuppliedData]];
	}
}

- (void)getPatients:(NSString *)name
{
	NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:NSStringFromSelector(@selector(creationDate)) ascending:YES];
	
	if(name.length)
	{
		NSString *query = [NSString stringWithFormat:@"%@ CONTAINS[c] '%@'", NSStringFromSelector(@selector(name)), name];
		[Patient where:query sort:@[sortDescriptor] success:^(id items) {
			[self.delegate patientController:self gotPatients:items error:nil];
		}];
	}
	else
	{
		[Patient all:@[sortDescriptor] success:^(id items) {
			[self.delegate patientController:self gotPatients:items error:nil];
		}];
	}
}

- (void)removePatient:(Patient *)patient
{
	[Patient destroyObject:patient success:^{
		[self.delegate patientController:self removedPatient:patient error:nil];
	} failure:^(NSError *error) {
		[self.delegate patientController:self removedPatient:patient error:error];
	}];
}

@end
