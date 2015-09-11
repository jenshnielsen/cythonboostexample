from cython.operator cimport dereference as deref

cdef extern from "myclass.h" namespace "myexample":
    cdef cppclass myclass:
        myclass()
        void dosomething()
        

cdef class mypyclass:
    cdef myclass *_thisptr
    def __cinit__(self):
        self._thisptr = new myclass()

    def __init__(self):
        pass

    def __dealloc__(self):
        if self._thisptr != NULL:
            del self._thisptr

    def dosomething(self):
        deref(self._thisptr).dosomething()
