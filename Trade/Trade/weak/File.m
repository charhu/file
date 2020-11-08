// RefcountMap disguises its pointers because we 
// don't want the table to act as a root for `leaks`.

typedef objc::DenseMap<DisguisedPtr<objc_object>,size_t,RefcountMapValuePurgeable> RefcountMap;

struct weak_table_t {

    weak_entry_t *weak_entries;
    size_t    num_entries;
    uintptr_t mask;
    uintptr_t max_hash_displacement;
};
   

struct SideTable {

    spinlock_t slock;           // 自旋锁
    RefcountMap refcnts;        // 引用计数散列表
    weak_table_t weak_table;    // 弱引用表
    SideTable() {
        memset(&weak_table, 0, sizeof(weak_table));
    }
    ~SideTable() {
        _objc_fatal("Do not delete SideTable.");
    }
    void lock() { slock.lock(); }
    void unlock() { slock.unlock(); }
    void forceReset() { slock.forceReset(); }
    template<HaveOld, HaveNew>
    static void lockTwo(SideTable *lock1, SideTable *lock2);
    template<HaveOld, HaveNew>
    static void unlockTwo(SideTable *lock1, SideTable *lock2);
};



union isa_t {

    isa_t() { }
    isa_t(uintptr_t value) : bits(value) { }
    Class cls;
    uintptr_t bits;    
#if defined(ISA_BITFIELD)

    struct {
        ISA_BITFIELD;  // defined in isa.h
    };
#endif
};

.#   define ISA_BITFIELD     

      uintptr_t nonpointer        : 1;                                       \
      uintptr_t has_assoc         : 1;                                       \
      uintptr_t has_cxx_dtor      : 1;                                       \
      uintptr_t shiftcls          : 33; /*MACH_VM_MAX_ADDRESS 0x1000000000*/ \
      uintptr_t magic             : 6;                                       \
      uintptr_t weakly_referenced : 1;                                       \
      uintptr_t deallocating      : 1;                                       \
      uintptr_t has_sidetable_rc  : 1;                                       \
      uintptr_t extra_rc          : 19


inline uintptr_t  objc_object::rootRetainCount(){

    if (isTaggedPointer()) return (uintptr_t)this;
    sidetable_lock();
    isa_t bits = LoadExclusive(&isa.bits);
    ClearExclusive(&isa.bits);
    if (bits.nonpointer) {
        uintptr_t rc = 1 + bits.extra_rc;
        if (bits.has_sidetable_rc) {
            rc += sidetable_getExtraRC_nolock();
        }
        sidetable_unlock();
        return rc;
    }
    sidetable_unlock();
    return sidetable_retainCount();
}

size_t objc_object::sidetable_getExtraRC_nolock(){
    
    ASSERT(isa.nonpointer);
    SideTable& table = SideTables()[this];
    RefcountMap::iterator it = table.refcnts.find(this);
    if (it == table.refcnts.end()) return 0;    
    else return it->second >> SIDE_TABLE_RC_SHIFT;
}

static StripedMap<SideTable>& SideTables() {

    return SideTablesMap.get();
}

iterator find(const_arg_type_t<KeyT> Val) {

   BucketT *TheBucket;
   if (LookupBucketFor(Val, TheBucket))
   
     return makeIterator(TheBucket, getBucketsEnd(), true);
   return end();
 }


uintptr_t
objc_object::sidetable_retainCount()
{
    SideTable& table = SideTables()[this];

    size_t refcnt_result = 1;
    
    table.lock();
    RefcountMap::iterator it = table.refcnts.find(this);
    if (it != table.refcnts.end()) {
        // this is valid for SIDE_TABLE_RC_PINNED too
        refcnt_result += it->second >> SIDE_TABLE_RC_SHIFT;
    }
    table.unlock();
    return refcnt_result;
}

SIDE_TABLE_RC_SHIFT = 2



static inline bool 
_objc_isTaggedPointer(const void * _Nullable ptr){

    return ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
}
