// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#include "Common/CBuilder.hpp"

#include "Cons3D.hpp"

namespace CF {
namespace Physics {
namespace NavierStokes {

////////////////////////////////////////////////////////////////////////////////////

Common::ComponentBuilder < NavierStokes::Cons3D,
                           Physics::Variables,
                           LibNavierStokes >
                           Builder_Cons3D;

Cons3D::Cons3D(const std::string& name) : VariablesT<Cons3D>(name)
{
}

Cons3D::~Cons3D() {}

////////////////////////////////////////////////////////////////////////////////////

} // NavierStokes
} // Physics
} // CF
