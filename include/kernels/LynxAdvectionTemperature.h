/******************************************************************************/
/*                       LYNX, a MOOSE-based application                      */
/*                                                                            */
/*          Copyright (C) 2017 by Antoine B. Jacquey and Mauro Cacace         */
/*             GFZ Potsdam, German Research Centre for Geosciences            */
/*                                                                            */
/*    This program is free software: you can redistribute it and/or modify    */
/*    it under the terms of the GNU General Public License as published by    */
/*      the Free Software Foundation, either version 3 of the License, or     */
/*                     (at your option) any later version.                    */
/*                                                                            */
/*       This program is distributed in the hope that it will be useful,      */
/*       but WITHOUT ANY WARRANTY; without even the implied warranty of       */
/*        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the       */
/*                GNU General Public License for more details.                */
/*                                                                            */
/*      You should have received a copy of the GNU General Public License     */
/*    along with this program. If not, see <http://www.gnu.org/licenses/>     */
/******************************************************************************/

#ifndef LYNXADVECTIONTEMPERATURE_H
#define LYNXADVECTIONTEMPERATURE_H

#include "LynxAdvectionBase.h"

class LynxAdvectionTemperature;

template <>
InputParameters validParams<LynxAdvectionTemperature>();

class LynxAdvectionTemperature : public LynxAdvectionBase
{
public:
  LynxAdvectionTemperature(const InputParameters & parameters);

protected:
  virtual Real computeArtificialViscosity() override;
  virtual void computeEntropyResidual();

  // diffusion residual
  const MaterialProperty<Real> & _thermal_diff;
  // source term residual
  Real _coeff_Hs;
  const MaterialProperty<Real> & _rhoC;
  const MaterialProperty<Real> & _radiogenic_heat;
  const MaterialProperty<Real> & _inelastic_heat;
};

#endif // LYNXADVECTIONTEMPERATURE_H
