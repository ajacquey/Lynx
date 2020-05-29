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

#include "LynxADMaterialBase.h"

class LynxADCreepModel : public LynxADMaterialBase
{
public:
  static InputParameters validParams();
  LynxADCreepModel(const InputParameters & parameters);
  void setQp(unsigned int qp);
  virtual void creepUpdate(ADRankTwoTensor & stress_dev,
                           const ADReal & pressure,
                           const Real & G,
                           ADRankTwoTensor & elastic_strain_incr);
  void resetQpProperties() final {}
  void resetProperties() final {}

protected:
  virtual ADReal viscousIncrement(const ADReal & pressure, const ADReal & eqv_stress, const Real & G);
  virtual ADReal computeQpEffectiveViscosity(const ADReal & pressure);
  virtual ADReal computeQpOneOnDiffViscosity(const ADReal A);
  virtual ADReal computeQpOneOnDislViscosity(const ADReal A, const ADReal n, const ADReal eII);
  virtual void initCreepParameters(const ADReal & pressure);
  virtual ADReal iterativeResidual(const ADReal & x);
  virtual ADReal iterativeResidualDerivative(const ADReal & x);
  virtual ADReal newtonRoot();
  virtual ADReal brentRoot(const ADReal & x1, const ADReal x2);
  virtual ADReal safeNewtonRoot(const ADReal & x1, const ADReal x2);

  const bool _coupled_temp;
  const ADVariableValue & _temp;

  // Creep parameters
  const bool _has_diffusion_creep;
  const std::vector<Real> _A_diffusion;
  const std::vector<Real> _E_diffusion;
  const std::vector<Real> _V_diffusion;
  const bool _has_dislocation_creep;
  const std::vector<Real> _A_dislocation;
  const std::vector<Real> _n_dislocation;
  const std::vector<Real> _E_dislocation;
  const std::vector<Real> _V_dislocation;
  const Real _gas_constant;
  const bool _has_background_strain_rate;
  const bool _has_initial_viscosity;
  const std::vector<Real> _initial_viscosity;
  const Real _background_strain_rate;
  const std::vector<Real> _eta_min;
  const std::vector<Real> _eta_max;
  const unsigned int _viscous_update;
  const Real _tol;
  const unsigned int _itmax;

  // Creep properties
  ADMaterialProperty<Real> & _eta_eff;
  ADMaterialProperty<RankTwoTensor> & _viscous_strain_incr;

  // Creep effective parameters
  ADReal _A_diff;
  Real _E_diff;
  Real _V_diff;

  ADReal _A_disl;
  Real _n_disl;
  Real _E_disl;
  Real _V_disl;

  // For iterative update
  ADReal _tau_II_tr;
  Real _G;
};