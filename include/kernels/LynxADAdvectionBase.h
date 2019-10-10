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

#include "ADTimeKernel.h"

#define usingAdvectionBaseMembers                                                                  \
  usingTimeKernelMembers;                                                                          \
  using LynxADAdvectionBase<compute_stage>::_beta_stabilization;                                   \
  using LynxADAdvectionBase<compute_stage>::_cr_stabilization;                                     \
  using LynxADAdvectionBase<compute_stage>::_value_old;                                            \
  using LynxADAdvectionBase<compute_stage>::_value_older;                                          \
  using LynxADAdvectionBase<compute_stage>::_vel_old;                                              \
  using LynxADAdvectionBase<compute_stage>::_vel_older;                                            \
  using LynxADAdvectionBase<compute_stage>::_entropy_old;                                          \
  using LynxADAdvectionBase<compute_stage>::_entropy_older;                                        \
  using LynxADAdvectionBase<compute_stage>::_gradient_old;                                         \
  using LynxADAdvectionBase<compute_stage>::_gradient_older;                                       \
  using LynxADAdvectionBase<compute_stage>::_second_old;                                           \
  using LynxADAdvectionBase<compute_stage>::_second_older;                                         \
  using LynxADAdvectionBase<compute_stage>::_pp_max_vel;                                           \
  using LynxADAdvectionBase<compute_stage>::_pp_avg_var;                                           \
  using LynxADAdvectionBase<compute_stage>::_pp_max_entropy;                                       \
  using LynxADAdvectionBase<compute_stage>::_pp_min_entropy;                                       \
  using LynxADAdvectionBase<compute_stage>::_pp_avg_entropy;                                       \
  using LynxADAdvectionBase<compute_stage>::_residual

template <ComputeStage>
class LynxADAdvectionBase;

declareADValidParams(LynxADAdvectionBase);

template <ComputeStage compute_stage>
class LynxADAdvectionBase : public ADTimeKernel<compute_stage>
{
public:
  LynxADAdvectionBase(const InputParameters & parameters);

protected:
  virtual void precalculateResidual() override;
  virtual ADReal computeQpResidual() override;
  virtual Real computeElementDiameter();
  virtual ADReal computeArtificialViscosity() = 0;

  const unsigned int _element_length_type;

  const Real _beta_stabilization;
  const Real _cr_stabilization;

  // velocities
  unsigned int _nvel;
  std::vector<const ADVariableValue *> _vel;
  std::vector<const VariableValue *> _vel_old;
  std::vector<const VariableValue *> _vel_older;

  //  old advected quantity
  const VariableValue & _value_old;
  const VariableGradient & _gradient_old;
  const VariableSecond & _second_old;

  //  older advected quantity
  const VariableValue & _value_older;
  const VariableGradient & _gradient_older;
  const VariableSecond & _second_older;

  // old and older entropy
  const VariableValue & _entropy_old;
  const VariableValue & _entropy_older;

  // postprocessor to get the global maxima and minima of all quantities
  const PostprocessorValue & _pp_max_vel;
  const PostprocessorValue & _pp_max_var;
  const PostprocessorValue & _pp_min_var;
  const PostprocessorValue & _pp_avg_var;
  const PostprocessorValue & _pp_max_entropy;
  const PostprocessorValue & _pp_min_entropy;
  const PostprocessorValue & _pp_avg_entropy;

  std::vector<ADReal> _residual;
  ADReal _artificial_viscosity;

  usingTimeKernelMembers;
};