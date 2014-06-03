//
//  Patient.h
//  IntervencaoNarrativa
//
//  Created by Luiz Soares dos Santos Baglie on 2014/06/01.
//  Copyright (c) 2014 Luiz Soares dos Santos Baglie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Patient : NSManagedObject

@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * examiner;
@property (nonatomic, retain) NSNumber * sexInteger;
@property (nonatomic, retain) NSDate * birthdate;

@property (nonatomic) FTINSex sex;

@end
