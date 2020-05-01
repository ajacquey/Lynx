# This test should give same results as viscoelastic_loading.i
# I forced dislocation creep to have a constant effective viscosity of 1.0e+22
# This is using the custom input for dislocation creep

[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 4
  ny = 4
  nz = 1
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 0.25
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
[]

[Kernels]
  [./mech_x]
    type = LynxADSolidMomentum
    variable = disp_x
    component = 0
  [../]
  [./mech_y]
    type = LynxADSolidMomentum
    variable = disp_y
    component = 1
  [../]
  [./mech_z]
    type = LynxADSolidMomentum
    variable = disp_z
    component = 2
  [../]
[]

[AuxVariables]
  [./Syy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Eyy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Ecyy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./eta_e]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Syy_aux]
    type = LynxADStressAux
    variable = Syy
    index_i = 1
    index_j = 1
  [../]
  [./Eyy_aux]
    type = LynxADStrainAux
    variable = Eyy
    index_i = 1
    index_j = 1
  [../]
  [./Ecyy_aux]
    type = LynxADStrainAux
    variable = Ecyy
    strain_type = viscous
    index_i = 1
    index_j = 1
  [../]
  [./eta_e_aux]
    type = ADMaterialRealAux
    variable = eta_e
    property = effective_viscosity
  [../]
[]

[BCs]
  [./no_ux]
    type = DirichletBC
    variable = disp_x
    boundary = left
    value = 0.0
    preset = true
  [../]
  [./ux_right]
    type = LynxVelocityBC
    variable = disp_x
    boundary = right
    value = -1.0e-14
  [../]
  [./no_uy]
    type = DirichletBC
    variable = disp_y
    boundary = top
    value = 0.0
    preset = true
  [../]
  [./uy_bottom]
    type = LynxVelocityBC
    variable = disp_y
    boundary = bottom
    value = -1.0e-14
  [../]
  [./no_uz]
    type = DirichletBC
    variable = disp_z
    boundary = 'front back'
    value = 0.0
    preset = true
  [../]
[]

[Materials]
  [./elastic_mat]
    type = LynxADElasticDeformation
    displacements = 'disp_x disp_y disp_z'
    bulk_modulus = 1.0e+10
    shear_modulus = 1.0e+10
    creep_model = 'dislocation_creep'
  [../]
  [./dislocation_creep]
    type = LynxADCreepModel
    A_dislocation = 5.0e-23
    n_dislocation = 1.0
    viscous_update = 'newton_safe'
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-15 1E-10 20 50 ilu NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  end_time = 3.1536e+13
  dt = 3.1536e+11
[]

[Outputs]
  execute_on = 'TIMESTEP_END'
  print_linear_residuals = false
  perf_graph = true
  exodus = true
[]
