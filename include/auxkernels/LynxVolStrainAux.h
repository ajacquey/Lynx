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

#ifndef LYNXVOLSTRAINAUX_H
#define LYNXVOLSTRAINAUX_H

#include "LynxStrainAuxBase.h"

class LynxVolStrainAux;

template <>
InputParameters validParams<LynxVolStrainAux>();

class LynxVolStrainAux : public LynxStrainAuxBase
{
public:
  LynxVolStrainAux(const InputParameters & parameters);

protected:
  virtual Real computeValue() override;
};

#endif // LYNXVOLSTRAINAUX_H
