module common;
version (Posix){
    import core.sys.posix.sys.stat: stat_t, fstat;
    import core.sys.posix.unistd: sysconf, _SC_PAGESIZE, _SC_LEVEL2_CACHE_SIZE, _SC_LEVEL3_CACHE_SIZE;
}
else
{
    static assert(0, "Only posix OS is supported!");
}

import core.stdc.stdio: fileno;
import std.stdio: File;
import std.typecons: Tuple;
import std.exception: errnoEnforce;
debug import std.stdio: writefln;


alias Fragment = Tuple!(size_t, "start", size_t, "end");

@system nothrow
size_t getPageSize(){
    return cast(size_t) sysconf(_SC_PAGESIZE);
}


@system
getFileSize(scope ref File file){
    stat_t statbuf = void;
    int fd = fileno(file.getFP());
    errnoEnforce(fstat(fd, &statbuf) == 0);
    return statbuf.st_size;
}


@safe pure nothrow
getNbOfTasks(immutable size_t file_size, immutable size_t bufferSize){
    size_t nbTasks = 1;
    if (file_size > bufferSize)
        nbTasks = file_size / bufferSize;
    return nbTasks;
}


@safe pure nothrow
static size_t lineCounter(immutable(ubyte)[] data){
    size_t result=0;
    foreach(ref c; data){
        if( cast(char)c == '\n')
            result+=1;
    }
    return result;
};


@safe pure nothrow
static size_t lineCounter(ref scope const ubyte[] data){
    size_t result=0;
    foreach(ref c; data){
        if( cast(char)c == '\n')
            result+=1;
    }
    return result;
};


/*
@safe pure nothrow
alias lineCounter = (ubyte[] data){
    size_t result=0;
    foreach(ref c; data){
        if( cast(char)c == '\n')
            result+=1;
    }
    return result;
};*/



@safe pure nothrow
Fragment getFragment( immutable size_t step, immutable size_t chunkSize, immutable size_t bufferSize){
    immutable size_t start = step * chunkSize;
    immutable size_t end = ((step + 1) * chunkSize);
    Fragment fragment;
    fragment.start = start;
    if( end > bufferSize )
        fragment.end = bufferSize;
    else
        fragment.end = end;
    //debug writefln("step: %d, start %d, end %d", step, fragment.start, fragment.end);
    return fragment;
}
