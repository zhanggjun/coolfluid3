// Copyright (C) 2010 von Karman Institute for Fluid Dynamics, Belgium
//
// This software is distributed under the terms of the
// GNU Lesser General Public License version 3 (LGPLv3).
// See doc/lgpl.txt and doc/gpl.txt for the license text.

#ifndef CF_Physics_DynamicModel_hpp
#define CF_Physics_DynamicModel_hpp

#include "Physics/PhysModel.hpp"

#include "Math/Defs.hpp"
#include "Math/MatrixTypes.hpp"

#include "LibPhysics.hpp"
#include <boost/scoped_ptr.hpp>

namespace CF {
namespace Physics {

//////////////////////////////////////////////////////////////////////////////////////////////

class Physics_API DynamicModel : public Physics::PhysModel {

public: // typedefs

  // no enum _ndim defined
  // no enum _neqs defined

  typedef RealMatrix    GeoV;  ///< type of geometry coordinates vector
  typedef RealVector    SolV;  ///< type of solution variables vector
  typedef RealMatrix    SolM;  ///< type of solution gradient matrix

public: // functions

  /// Constructor
  DynamicModel ( const std::string& name );

  /// Destructor
  virtual ~DynamicModel();

  /// Get the class name
  static std::string type_name () { return "DynamicModel"; }

  /// physical properties
  struct Properties : public Physics::Properties
  {
  };

  /// @name INTERFACE
  //@{

  /// @returns the dimensionality of this model
  virtual Uint ndim() const;
  /// @returns the number of equations
  virtual Uint neqs() const;
  /// @return the physical model generic type
  virtual std::string model_type() const { return "Dynamic"; }
  /// @return the physical model type
  virtual std::string type() const;

  /// create a physical properties
  virtual std::auto_ptr<Physics::Properties> create_properties()
  {
    return std::auto_ptr<Physics::Properties>( new DynamicModel::Properties() );
  }

  /// Create a Variables component
  /// @param type is the name of the Variables
  /// @post the component will be a sub-component of this model but maybe be moved away
  /// @throws ValueNotFound if the type does not match a variable type this model supports
  virtual boost::shared_ptr< Physics::Variables > create_variables( const std::string type, const std::string name );

  //@} END INTERFACE

private: // data
  class Implementation;
  boost::scoped_ptr<Implementation> m_implementation;

}; // DynamicModel

//////////////////////////////////////////////////////////////////////////////////////////////

} // Physics
} // CF

#endif // CF_Physics_DynamicModel_hpp
