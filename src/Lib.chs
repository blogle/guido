{-# Language ForeignFunctionInterface #-}

module Lib where

#include "Python.h"

import Foreign
import Foreign.C

data PyObjectHeadExtra -- Define pointers to support a doubly-linked list of all live heap objects.

-- The initial segment of all python types
data PyObjectHead = PyObjectHead
  { heapPtr :: PyObjectHeadExtra
  , refcnt  :: CInt }

-- Every pointer to a python object can be cast to a PyObject*
data PyObject = PyObject PyObjectHead

-- Flag passed to newmethodobject
methVARARGS = 0x0001
methNOARGS  = 0x0004

-- METH_CLASS and METH_STATIC are a little different; these control
-- the construction of methods for a class. These cannot be used for
-- functions in modules.
methCLASS  = 0x0010
methSTATIC = 0x0020

-- Type of the functions used to implement most Python callables
-- in C. Functions of this type take two PyObject* and return one
-- PyObject. If the return value is NULL an Exception will be set.
-- If not NULL, the return value is interpreted as the return value
-- of the function as exposed to Python. The function must return a
-- *New* reference
type PyCFunction = Ptr PyObject -> Ptr PyObject -> Ptr PyObject

data PyMethodDef = PyMethodDef
  { ml_name  :: CString     -- The name of the built-in function/method
  , ml_meth  :: PyCFunction -- The C function that implements it
  , ml_flags :: CInt        -- Combination of METH_xxx flags, which mostly
                            -- describe the args expected by the C func
  , ml_doc   :: CString     -- The __doc__ attribute, or NULL
  }

data PyCFunctionObject = PyCFunctionObject
  { pyobjh   :: PyObjectHead
  , m_ml     :: PyMethodDef -- Description of the C function to call
  , m_self   :: PyObject    -- Passed as 'self' arg to the C func, can be NULL
  , m_module :: PyObject    -- The __module__ attribute, can be anything
  }

-- This is used to wrap haskell data types and expose them to python
data PyHaskellObj a = Opaque PyObjectHead (StablePtr a)
