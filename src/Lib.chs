{-# Language ForeignFunctionInterface #-}

module Lib where

#include "Python.h"

import Foreign
import Foreign.C

data PyObjectHeadExtra -- Define pointers to support a doubly-linked list of all live heap objects.

-- The initial segment of all python types
type PyObjectHead = Ptr ()
-- = PyObjectHead
--  { heapPtr :: PyObjectHeadExtra
--  , refcnt  :: CInt }

type PyObjectVarHead = Ptr ()

-- Every pointer to a python object can be cast to a PyObject*
data PyObject = PyObject PyObjectHead

type PySSizeT     = {#type Py_ssize_t#}

type FreeFunc     = Ptr () -> IO ()
type Destructor   = Ptr PyObject -> IO ()
type PrintFunc    = Ptr PyObject -> Ptr CFile -> CInt -> IO CInt
type GetAttrFunc  = Ptr PyObject -> CString -> IO (Ptr PyObject)
type GetAttrOFunc = Ptr PyObject -> Ptr PyObject -> IO (Ptr PyObject)

type SetAttrFunc  = Ptr PyObject -> CString -> Ptr PyObject -> IO CInt
type SetAttrOFunc = Ptr PyObject -> Ptr PyObject -> Ptr PyObject -> IO CInt

type CmpFunc      = Ptr PyObject -> Ptr PyObject -> IO CInt
type ReprFunc     = Ptr PyObject -> IO (Ptr PyObject)
type HashFunc     = Ptr PyObject -> IO CLong
type RichCmpFunc  = Ptr PyObject -> Ptr PyObject -> CInt -> IO (Ptr PyObject)
type GetIterFunc  = Ptr PyObject -> IO (Ptr PyObject)
type IterNextFunc = Ptr PyObject -> IO (Ptr PyObject)
type InitProc     = Ptr PyObject -> Ptr PyObject -> Ptr PyObject -> IO CInt
type NewFunc      = Ptr PyTypeObject -> PySSizeT -> IO (Ptr PyObject)
type AllocFunc    = Ptr PyTypeObject -> PySSizeT -> IO (Ptr PyObject)
type Inquiry      = Ptr PyObject -> IO CInt
type DescrGetFunc = Ptr PyObject -> Ptr PyObject -> Ptr PyObject -> IO (Ptr PyObject)
type DescrSetFunc = Ptr PyObject -> Ptr PyObject -> Ptr PyObject -> IO CInt

type TernaryFunc  = Ptr PyObject -> Ptr PyObject -> Ptr PyObject -> IO (Ptr PyObject)

type VisitProc    = Ptr PyObject -> Ptr () -> IO CInt
type TraverseProc = Ptr PyObject -> VisitProc -> Ptr () -> IO CInt

type PyBufferProcs     = {#type PyBufferProcs#}
type PyNumberMethods   = {#type PyNumberMethods #}
type PySequenceMethods = {#type PySequenceMethods #}
type PyMappingMethods  = {#type PyMappingMethods #}

data PyMemberDef = PyMemberDef 
  { name   :: CString
  , tag    :: CInt
  , offset :: PySSizeT
  , flags  :: CInt
  , doc    :: CString
  }

type Getter = Ptr PyObject -> Ptr () -> IO (Ptr PyObject)
type Setter = Ptr PyObject -> Ptr PyObject -> Ptr () -> IO CInt

data PyGetSetDef = PyGetSetDef
  { name'   :: CString
  , get     :: Getter
  , set     :: Setter
  , doc'    :: CString
  , closure :: Ptr ()
  } 

-- This is used to wrap haskell data types and expose them to python
data PyHaskellObj a = Opaque PyObjectHead (IO (StablePtr a))

{-                                       TESTING                                               -}

--typedef struct {
--  PyObjectHEAD
--  /* type specific fields */
--} noddy_NoddyObject

noddyObject = Opaque nullptr (newStablePtr ())

-- static PyTypeObject noddy_NoddyType {
--     PyObject_HEAD_INIT(NULL),
--     0,                   /* ob_size */ 
--     "noddy.Noddy",       /* tp_name */ 
--     sizeof(NoddyObject), /* tp_basicsize */ 
--     0,                   /* tp_itemsize */ 
--     0,                   /* tp_dealloc */ 
--     0,                   /* tp_print */ 
--     0,                   /* tp_getattr */ 
--     0,                   /* tp_setattr */ 
--     0,                   /* tp_compare */ 
--     0,                   /* tp_repr */ 
--     0,                   /* tp_as_number */ 
--     0,                   /* tp_as_sequence */ 
--     0,                   /* tp_as_mapping */ 
--     0,                   /* tp_hash */ 
--     0,                   /* tp_call */ 
--     0,                   /* tp_str */ 
--     0,                   /* tp_getattro */ 
--     0,                   /* tp_setattro */ 
--     0,                   /* tp_as_buffer */ 
--     Py_TPFLAGS_DEFAULT,  /* tp_flags */
--     "Noddy Objects"      /* tp_doc */
-- }

-- static PyMethodDef noddy_Methods[] = {
-- {NULL} /* Sentinel Value */
-- }

-- PyMODINIT_FUNC initnoddy(void) {
--     PyObject* m;
--
--     noddy_NoddyType.tp_new = PyTypeGenericNew;
--     if (PyType_Ready(&noddy_NoddyType) < 0) {
--         return;
--     }
-- 
--     m = Py_InitModule3("noddy", noddy_methods, "Example Python module creating a type");
--     Py_Incref(&noddy_NoddyType);
--
--     PyModule_AddObject(m, "Noddy", (PyObject*)&noddy_NoddyType)
