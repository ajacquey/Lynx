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

#include "TimeStepper.h"

class LynxLogConstantDT : public TimeStepper
{
public:
  static InputParameters validParams();
  LynxLogConstantDT(const InputParameters & parameters);

protected:
  virtual Real computeInitialDT() override;
  virtual Real computeDT() override;

private:
  const Real _log_dt;
  const Real _first_dt;
  const Real _max_dt;
  const Real _dt_factor;
  const Real _growth_factor;
};