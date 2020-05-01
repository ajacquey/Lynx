[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 2
  ny = 2
  nz = 10
  xmin = 0
  xmax = 6
  ymin = 0
  ymax = 6
  zmin = 0
  zmax = 30
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
  [./disp_z]
  [../]
  [./p_lith]
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
  [./lithostatic_pressure]
    type = LynxADPressureLoad
    variable = p_lith
  [../]
[]

[AuxVariables]
  [./strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./strain_zz]
    type = LynxADStrainAux
    variable = strain_zz
    index_i = 2
    index_j = 2
  [../]
  [./stress_zz]
    type = LynxADStressAux
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
[]

[BCs]
  [./no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right'
    value = 0.0
    preset = true
  [../]
  [./no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom top'
    value = 0.0
    preset = true
  [../]
  [./no_z]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value = 0.0
    preset = true
  [../]
  [./plith_top]
    type = DirichletBC
    variable = p_lith
    boundary = front
    value = 0.0
  [../]
[]

[Materials]
  [./elastic_mat]
    type = LynxADElasticDeformation
    displacements = 'disp_x disp_y disp_z'
    lithostatic_pressure = p_lith
    bulk_modulus = 6.6666667e+09
    shear_modulus = 4.0e+09
  [../]
  [./density]
    type = LynxADDensityConstant
    solid_density = 3058.104
    has_gravity = true
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it -sub_pc_type -sub_pc_factor_shift_type'
    petsc_options_value = 'gmres asm 1E-10 1E-10 200 500 lu NONZERO'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  automatic_scaling = true
  start_time = 0.0
  end_time = 1.0
  dt = 1.0
[]

[Outputs]
  execute_on = 'TIMESTEP_END'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
[]