#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <IOKit/IOKitLib.h>
#include <Cocoa/Cocoa.h>

@interface IdleTime: NSObject
{
@protected
    
    mach_port_t   ioPort;
    io_iterator_t ioIterator;
    io_object_t   ioObject;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) uint64_t timeIdle;
@property( readonly ) NSUInteger secondsIdle;

@end