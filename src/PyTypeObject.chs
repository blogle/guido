{-# Language ForeignFunctionInterface #-}

module PyTypeObject (
  PyTypeObject
) where

#include "Python.h"

import Foreign
import Foreign.C

data PyTypeObject  = PyTypeObject 
  { pyvobjh :: PyObjectVarHead
  , tp_name :: CString      -- For printing, in format "<module>.<name>"
   
    -- For allocation
  , tp_basicsize :: PySSizeT
  , tp_itemsize  :: PySSizeT

    -- Methods to implement standard operations
  , tp_dealloc :: Destructor
  , tp_print   :: PrintFunc
  , tp_getattr :: GetAttrFunc
  , tp_setattr :: SetAttrFunc
  , tp_compare :: CmpFunc
  , tp_repr    :: ReprFunc

    -- Method suites for standard classes
  , tp_as_number   :: Ptr PyNumberMethods
  , tp_as_sequence :: Ptr PySequenceMethods
  , tp_as_mapping  :: Ptr PyMappingMethods

    -- More standard operations (here for binary compatibility)
  , tp_hash :: HashFunc
  , tp_call :: TernaryFunc
  , tp_str  :: ReprFunc
  , tp_getattro :: GetAttrOFunc
  , tp_setattro :: SetAttrOFunc

    -- Functions to access object as input/output buffer
  , tp_as_buffer :: Ptr PyBufferProcs

    -- Flags to define presence of optional/expanded features
  , tp_flags :: CLong
    
    -- Documentation string
  , tp_doc   :: CString
    
    --Call function for all accessible objects
  , tp_traverse :: TraverseProc

    -- Delete references to contained objects
  , tp_clear :: Inquiry

    -- Rich comparisons
  , tp_richcompare :: RichCmpFunc

    -- Weak reference enabler
  , tp_weaklistoffset :: PySSizeT

    -- Iterators
  , tp_iter :: GetIterFunc
  , tp_iternext :: IterNextFunc

    -- Attribute descriptor and subclassing stuff
  , tp_methods :: Ptr PyMethodDef
  , tp_members :: Ptr PyMemberDef
  , tp_getset  :: Ptr PyGetSetDef
  , tp_base    :: Ptr PyTypeObject
  , tp_dict    :: Ptr PyObject

  , tp_descr_get  :: DescrGetFunc
  , tp_descr_set  :: DescrSetFunc
  , tp_dictoffset :: PySSizeT

  , tp_init  :: InitProc
  , tp_alloc :: AllocFunc
  , tp_new   :: NewFunc

    -- Low-level free-memory routine
  , tp_free  :: FreeFunc     

    -- For PyObject_IS_GC
  , tp_is_gc :: Inquiry      
  , tp_bases :: Ptr PyObject

    -- Method resolution order
  , tp_mro   :: Ptr PyObject   
  , tp_cache :: Ptr PyObject

  , tp_subclasses :: Ptr PyObject
  , tp_weaklist   :: Ptr PyObject

  , tp_del   :: Destructor 

    -- Type attribute cache version tag.
  , tp_version_tag :: CUInt

    -- These must be last and NEVER explicitly initialized
  , tp_allocs   :: PySSizeT
  , tp_frees    :: PySSizeT
  , tp_maxalloc :: PySSizeT

  , tp_prev :: Ptr PyTypeObject
  , tp_next :: Ptr PyTypeObject
}
