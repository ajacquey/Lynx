/******************************************************************************/
/*                            This file is part of                            */
/*                       LYNX, a MOOSE-based application                      */
/*                    Lithosphere dYnamic Numerical toolboX                   */
/*                                                                            */
/*          Copyright (C) 2017 by Antoine B. Jacquey and Mauro Cacace         */
/*             GFZ Potsdam, German Research Centre for Geosciences            */
/*                                                                            */
/*                Licensed under GNU General Public License 3,                */
/*                       please see LICENSE for details                       */
/*                  or http://www.gnu.org/licenses/gpl.html                   */
/******************************************************************************/

#pragma once

#include "LynxThermalBase.h"

class LynxThermalConstant;

template <>
InputParameters validParams<LynxThermalConstant>();

class LynxThermalConstant : public LynxThermalBase
{
public:
  LynxThermalConstant(const InputParameters & parameters);

protected:
  virtual void computeQpHeatCap() override;
  virtual void computeQpThermalCond() override;
  virtual void computeQpThermalExp() override;

  const std::vector<Real> _fluid_thermal_cond;
  const std::vector<Real> _solid_thermal_cond;
  const std::vector<Real> _fluid_heat_cap;
  const std::vector<Real> _solid_heat_cap;
  const std::vector<Real> _fluid_thermal_exp;
  const std::vector<Real> _solid_thermal_exp;
};