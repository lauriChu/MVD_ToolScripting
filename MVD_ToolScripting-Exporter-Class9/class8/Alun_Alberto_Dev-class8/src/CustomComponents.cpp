//
//  Copyright � 2018 Alun Evans. All rights reserved.
//
//  This file contains the definitions of an entity, and all the different types of component
//  At the end is a struct called the EntityComponentManager (ECM) which contains an std::vector for
//  each of the different component types, stored in an std::tuple. The advantage of this system is that
//  if a system wishes to interact/use/update all components of a certain type (e.g. draw all meshes),
//  then these components are stored in contiguous memory, which the various levels of caching can use
//  to improve performance
//
//    TO ADD A NEW COMPONENT TYPE:
//    - define it as a sub-class of Component
//    - add it to the ComponentArrays tuple
//    - add it as a subtemplate of typetoint() and increment 'result' variable
//    - increment NUM_TYPE_COMPONENTS
//
#pragma once
#include "CustomComponents.h"
