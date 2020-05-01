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

#include "InitialCondition.h"

class LynxFunctionNoiseIC : public InitialCondition
{
public:
  static InputParameters validParams();
  LynxFunctionNoiseIC(const InputParameters & parameters);

protected:
  virtual Real value(const Point & p) override;
  virtual RealGradient gradient(const Point & p) override;

  const Function & _func;
  Real _rand_per;
};