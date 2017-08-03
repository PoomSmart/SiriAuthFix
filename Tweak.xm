#import <sys/sysctl.h>
#import <substrate.h>

typedef mach_port_t io_object_t;
typedef io_object_t io_registry_entry_t;
typedef UInt32 IOOptionBits;

extern "C" CFTypeRef IORegistryEntryCreateCFProperty(io_registry_entry_t entry,  CFStringRef key, CFAllocatorRef allocator, IOOptionBits options);

static CFTypeRef (*orig_registryEntry)(io_registry_entry_t entry,  CFStringRef key, CFAllocatorRef allocator, IOOptionBits options);
CFTypeRef replaced_registryEntry(io_registry_entry_t entry,  CFStringRef key, CFAllocatorRef allocator, IOOptionBits options) {
    CFTypeRef retval = NULL;
    if (CFEqual(key, CFSTR("model")))
        retval = CFDataCreate(kCFAllocatorDefault, (const unsigned char *)"iPhone4,1", 10);
    else
        retval = orig_registryEntry(entry, key, allocator, options);
    return retval;
}

static int (*orig_ctl)(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen);
int replaced_ctl(const char *name, void *oldp, size_t *oldlenp, void *newp, size_t newlen) {
    if (strcmp(name, "hw.machine") == 0) {
    	if (oldp)
        	strcpy((char *)oldp, "iPhone4,1");
        *oldlenp = sizeof("iPhone4,1");
    }
    else if (strcmp(name, "hw.model") == 0) {
    	if (oldp)
        	strcpy((char *)oldp, "N94AP");
        *oldlenp = sizeof("N94AP");
    }
    return orig_ctl(name, oldp, oldlenp, newp, newlen);
}


__attribute__((constructor)) static void SiriAuthFixInit() {
	MSHookFunction((void *)IORegistryEntryCreateCFProperty, (void *)replaced_registryEntry, (void **)&orig_registryEntry);
    MSHookFunction((void *)sysctlbyname, (void *)replaced_ctl, (void **)&orig_ctl);
}