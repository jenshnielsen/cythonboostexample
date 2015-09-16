from cython.operator cimport dereference as deref
from libcpp.string cimport string
from libcpp cimport bool as cbool

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

cdef extern from "myclass.h" namespace "boost::property_tree":

    cdef cppclass c_ParameterList "boost::property_tree::ptree":
        c_ParameterList()
        c_ParameterList& assign "operator="(const c_ParameterList&)
        void put_bool "put<bool>" (char*, cbool)
        void put_string "put<std::string>" (char*, string)
        void put_int "put<int>" (char*, int)
        void put_double "put<double>" (char*, double)
        string get_string "get<std::string>" (char*)
        int get_int "get<int>" (char*)
        double get_double "get<double>" (char*)
        cbool get_bool "get<bool>" (char*)

cdef extern from "<sstream>" namespace "std":
    cdef cppclass ostringstream:
        ostringstream() except +
        ostringstream(string) except +
        string str()
        void str(string)
        void clear()

    cdef cppclass istringstream:
            istringstream() except +
            istringstream(string) except +
            string str()
            void str(string)
            void clear()

cdef extern from "boost/property_tree/json_parser.hpp" namespace "boost::property_tree::json_parser":

    void write_json(string, c_ParameterList)
    void write_json(ostringstream, c_ParameterList, cbool)
    void read_json(istringstream, c_ParameterList)


cdef class ParameterList:
    cdef c_ParameterList* impl_
    cdef ostringstream* outputter_
    cdef istringstream* inputter_

    def __cinit__(self):
        self.impl_ = new c_ParameterList()
        self.outputter_ = new ostringstream()

    def __init__(self):
        pass

    def __dealloc__(self):
        del self.impl_
        del self.outputter_

    def write_state(self):
        write_json("test.json", deref(self.impl_))

    def get_string(self):
        self._serialize()
        return deref(self.outputter_).str()

    def _serialize(self):
        deref(self.outputter_).str("");
        deref(self.outputter_).clear();
        write_json(deref(self.outputter_), deref(self.impl_), False)

    def __getstate__(self):
        self._serialize()
        state = dict()
        state['repr'] = deref(self.outputter_).str()
        return state

    def __setstate__(self, state):
        self.impl_ = new c_ParameterList()
        self.inputter_ = new istringstream(state['repr'])
        print(deref(self.inputter_).str())
        read_json(deref(self.inputter_), deref(self.impl_))
