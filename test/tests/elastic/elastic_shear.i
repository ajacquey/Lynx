[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 4
  ny = 4
  nz = 2
  xmin = 0
  xmax = 10
  ymin = 0
  ymax = 10
  zmin = 0
  zmax = 5
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
  [./Ev]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./S_dev]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Sxy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Exy]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Ev_aux]
    type = LynxADVolStrainAux
    variable = Ev
  [../]
  [./S_aux]
    type = LynxADVonMisesStressAux
    variable = S_dev
  [../]
  [./Sxy_aux]
    type = LynxADStressAux
    variable = Sxy
    index_i = 0
    index_j = 1
  [../]
  [./Exy_aux]
    type = LynxADStrainAux
    variable = Exy
    index_i = 0
    index_j = 1
  [../]
[]

[Functions]
  [./disp_y_func]
    type = ParsedFunction
    value = 'm*x'
    vars = 'm'
    vals = '-0.1'
  [../]
[]

[BCs]
  [./no_ux]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right bottom top front back'
    value = 0.0
    preset = true
  [../]
  [./no_uz]
    type = DirichletBC
    variable = disp_z
    boundary = 'left right bottom top front back'
    value = 0.0
    preset = true
  [../]
  [./disp_y_plate]
    type = LynxVelocityBC
    variable = disp_y
    boundary = 'left right bottom top front back'
    function = disp_y_func
  [../]
[]

[Materials]
  [./elastic_mat]
    type = LynxADElasticDeformation
    displacements = 'disp_x disp_y disp_z'
    bulk_modulus = 1.0e+09
    shear_modulus = 1.0e+09
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-10 1E-15 20 50 lu NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  end_time = 10.0
  dt = 1.0
[]

[Outputs]
  execute_on = 'TIMESTEP_END'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
[]