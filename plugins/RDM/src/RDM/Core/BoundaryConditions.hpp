// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#ifndef CF_RDM_BoundaryConditions_hpp
#define CF_RDM_BoundaryConditions_hpp

#include "Common/CActionDirector.hpp"

#include "RDM/Core/LibCore.hpp"

namespace CF {
namespace RDM {
namespace Core {

/////////////////////////////////////////////////////////////////////////////////////

class RDM_Core_API BoundaryConditions : public Common::CActionDirector {

public: // typedefs

  /// pointers
  typedef boost::shared_ptr<BoundaryConditions> Ptr;
  typedef boost::shared_ptr<BoundaryConditions const> ConstPtr;

public: // functions
  /// Contructor
  /// @param name of the component
  BoundaryConditions ( const std::string& name );

  /// Virtual destructor
  virtual ~BoundaryConditions() {}

  /// Get the class name
  static std::string type_name () { return "BoundaryConditions"; }

  /// execute the action
  virtual void execute ();

  /// @name SIGNALS
  //@{

  /// creates a boundary BC
  void signal_create_boundary_condition( Common::SignalArgs& args );
  /// signature for @see signal_create_boundary_condition
  void signature_signal_create_boundary_condition( Common::SignalArgs& node );

  //@} END SIGNALS

private:

  Common::CActionDirector::Ptr m_weak_bcs;   ///< set of weak bcs

  Common::CActionDirector::Ptr m_strong_bcs; ///< set of strong bcs

};

/////////////////////////////////////////////////////////////////////////////////////

} // Core
} // RDM
} // CF

#endif // CF_RDM_BoundaryConditions_hpp
