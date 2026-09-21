/*
 *  testvmx.h
 *  testkext
 *
 */

#include <IOKit/IOLib.h>
#include <IOKit/IOService.h>

class testvmx : public IOService {
  OSDeclareDefaultStructors(testvmx);

  virtual bool start(IOService *provider);

  virtual void stop(IOService *provider);
};
