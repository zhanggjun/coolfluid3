// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#include "Common/FindComponents.hpp"

#include "Common/CLink.hpp"
#include "Common/CBuilder.hpp"
#include "Mesh/CNodeFaceCellConnectivity.hpp"
#include "Mesh/CDynTable.hpp"
#include "Mesh/CNodes.hpp"
#include "Mesh/CRegion.hpp"

namespace CF {
namespace Mesh {

using namespace Common;

Common::ComponentBuilder < CNodeFaceCellConnectivity , Component, LibMesh > CNodeFaceCellConnectivity_Builder;

////////////////////////////////////////////////////////////////////////////////

CNodeFaceCellConnectivity::CNodeFaceCellConnectivity ( const std::string& name ) : 
  Component(name)
{
  m_nodes = create_static_component_ptr<Common::CLink>(Mesh::Tags::nodes());
  m_face_cell_connectivity = create_static_component_ptr<CUnifiedData>("elements");
  m_connectivity = create_static_component_ptr<CDynTable<Uint> >(Mesh::Tags::connectivity_table());
  mark_basic();
}

////////////////////////////////////////////////////////////////////////////////

void CNodeFaceCellConnectivity::setup(CRegion& region)
{
  boost_foreach(CFaceCellConnectivity& face2cells , find_components_recursively<CFaceCellConnectivity>(region))
    face_cell_connectivity().add(face2cells);
  build_connectivity();
}

////////////////////////////////////////////////////////////////////////////////

void CNodeFaceCellConnectivity::set_nodes(CNodes& nodes)
{
  m_nodes->link_to(nodes.self());
  m_connectivity->resize(nodes.size());
}

////////////////////////////////////////////////////////////////////////////////

void CNodeFaceCellConnectivity::build_connectivity()
{
  CNodes const& nodes = *m_nodes->follow()->as_ptr<CNodes>();
  
  // Reserve memory in m_connectivity->array()
  std::vector<Uint> connectivity_sizes(nodes.size());
  boost_foreach(Component::ConstPtr face_cell_connectivity_comp, m_face_cell_connectivity->components() )
  {
    const CFaceCellConnectivity& face_cell_connectivity = face_cell_connectivity_comp->as_type<CFaceCellConnectivity>();
    for (Uint f=0; f<face_cell_connectivity.size(); ++f)
    {
      if ( face_cell_connectivity.is_bdry_face()[f] )
      {
        boost_foreach (const Uint node_idx, face_cell_connectivity.face_nodes(f))
        {
          ++connectivity_sizes[node_idx];
        }
      }
    }
  }
  Uint i(0);
  boost_foreach (CDynTable<Uint>::Row row, m_connectivity->array() )
  {
    row.reserve(connectivity_sizes[i++]);
  }
  
  // fill m_connectivity->array()
  
  Uint glb_face_idx(0);
  boost_foreach(Component::ConstPtr face_cell_connectivity_comp, m_face_cell_connectivity->components() )
  {
    const CFaceCellConnectivity& face_cell_connectivity = face_cell_connectivity_comp->as_type<CFaceCellConnectivity>();
    for (Uint f=0; f<face_cell_connectivity.size(); ++f, ++glb_face_idx)
    {
      if ( face_cell_connectivity.is_bdry_face()[f] )
      {
        boost_foreach (const Uint node_idx, face_cell_connectivity.face_nodes(f))
        {
          m_connectivity->array()[node_idx].push_back(glb_face_idx);
        }
      }
    }
  }
  
}

////////////////////////////////////////////////////////////////////////////////

} // Mesh
} // CF
