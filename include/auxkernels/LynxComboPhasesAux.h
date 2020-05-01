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

#include "AuxKernel.h"

class LynxComboPhasesAux : public AuxKernel
{
public:
  static InputParameters validParams();
  LynxComboPhasesAux(const InputParameters & parameters);

protected:
  virtual Real computeValue();

  unsigned _n_composition;
  std::vector<const VariableValue *> _compositional_phases;
};
