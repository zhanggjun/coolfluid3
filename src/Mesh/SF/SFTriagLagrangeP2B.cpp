// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#include "Common/CBuilder.hpp"

#include "LibSF.hpp"
#include "SFTriagLagrangeP2B.hpp"

namespace CF {
namespace Mesh {
namespace SF {

////////////////////////////////////////////////////////////////////////////////

Common::ComponentBuilder < SFTriagLagrangeP2B, ShapeFunction, LibSF > SFTriagLagrangeP2B_Builder;

////////////////////////////////////////////////////////////////////////////////

SFTriagLagrangeP2B::SFTriagLagrangeP2B(const std::string& name) : ShapeFunction(name)
{
  m_dimensionality = dimensionality;
  m_nb_nodes = nb_nodes;
  m_order = order;
  m_shape = shape;
}

////////////////////////////////////////////////////////////////////////////////

void SFTriagLagrangeP2B::compute_value(const MappedCoordsT& mapped_coord, ValueT& result)
{
  const Real L0 = 1.0 - mapped_coord[KSI] - mapped_coord[ETA];
  const Real L1 = mapped_coord[KSI];
  const Real L2 = mapped_coord[ETA];

  const Real Phi6 = L0 * L1 * L2;

  result[0] = ( 2*L0 - 1.0 ) * L0 + 3 * Phi6 ;
  result[1] = ( 2*L1 - 1.0 ) * L1 + 3 * Phi6 ;
  result[2] = ( 2*L2 - 1.0 ) * L2 + 3 * Phi6 ;
  result[3] = 4*L0*L1 - 12. * Phi6 ;
  result[4] = 4*L1*L2 - 12. * Phi6 ;
  result[5] = 4*L2*L0 - 12. * Phi6 ;
  result[6] = 27 * Phi6;
}

////////////////////////////////////////////////////////////////////////////////

void SFTriagLagrangeP2B::compute_gradient(const MappedCoordsT& mapped_coord, GradientT& result)
{
  const Real L0 = 1.0 - mapped_coord[KSI] - mapped_coord[ETA];
  const Real L1 = mapped_coord[KSI];
  const Real L2 = mapped_coord[ETA];

  const Real DX_L0 = -1.;
  const Real DY_L0 = -1.;
  const Real DX_L1 =  1.;
  const Real DY_L1 =  0.;
  const Real DX_L2 =  0.;
  const Real DY_L2 =  1.;

  result(KSI, 0) = (4.*L0-1.)*DX_L0  + 3.*L1*L2*DX_L0 + 3.*L0*L2*DX_L1 + 3.*L0*L1*DX_L2;
  result(ETA, 0) = (4.*L0-1.)*DY_L0  + 3.*L1*L2*DY_L0 + 3.*L0*L2*DY_L1 + 3.*L0*L1*DY_L2;

  result(KSI, 1) =  (4.*L1-1.)*DX_L1 + 3.*L1*L2*DX_L0 + 3.*L0*L2*DX_L1 + 3.*L0*L1*DX_L2;
  result(ETA, 1) =  (4.*L1-1.)*DY_L1 + 3.*L1*L2*DY_L0 + 3.*L0*L2*DY_L1 + 3.*L0*L1*DY_L2;

  result(KSI, 2) =  (4.*L2-1.)*DX_L2 + 3.*L1*L2*DX_L0 + 3.*L0*L2*DX_L1 + 3.*L0*L1*DX_L2;
  result(ETA, 2) =  (4.*L2-1.)*DY_L2 + 3.*L1*L2*DY_L0 + 3.*L0*L2*DY_L1 + 3.*L0*L1*DY_L2;

  result(KSI, 3) = 4.*L1*DX_L0 + 4.*L0*DX_L1 - 12.*L1*L2*DX_L0 - 12.*L0*L2*DX_L1 - 12.*L0*L1*DX_L2;
  result(ETA, 3) = 4.*L1*DY_L0 + 4.*L0*DY_L1 - 12.*L1*L2*DY_L0 - 12.*L0*L2*DY_L1 - 12.*L0*L1*DY_L2;

  result(KSI, 4) = 4.*L2*DX_L1 + 4.*L1*DX_L2 - 12.*L1*L2*DX_L0 - 12.*L0*L2*DX_L1 - 12.*L0*L1*DX_L2;
  result(ETA, 4) = 4.*L2*DY_L1 + 4.*L1*DY_L2 - 12.*L1*L2*DY_L0 - 12.*L0*L2*DY_L1 - 12.*L0*L1*DY_L2;

  result(KSI, 5) = 4.*L2*DX_L0 + 4.*L0*DX_L2 - 12.*L1*L2*DX_L0 - 12.*L0*L2*DX_L1 - 12.*L0*L1*DX_L2;
  result(ETA, 5) = 4.*L2*DY_L0 + 4.*L0*DY_L2 - 12.*L1*L2*DY_L0 - 12.*L0*L2*DY_L1 - 12.*L0*L1*DY_L2;

  result(KSI, 6) = 27.*L1*L2*DX_L0 + 27.*L0*L2*DX_L1 + 27.*L0*L1*DX_L2;
  result(ETA, 6) = 27.*L1*L2*DY_L0 + 27.*L0*L2*DY_L1 + 27.*L0*L1*DY_L2;
}

////////////////////////////////////////////////////////////////////////////////

RealMatrix SFTriagLagrangeP2B::s_mapped_sf_nodes =  ( RealMatrix(7,2) <<
   0.,    0.,
   1.,    0.,
   0.,    1.,
   0.5,   0.,
   0.5,   0.5,
   0.,    0.5,
   1./3., 1./3.
).finished();

////////////////////////////////////////////////////////////////////////////////

} // SF
} // Mesh
} // CF
