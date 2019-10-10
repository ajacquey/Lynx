[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 2
  ny = 2
  nz = 2
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 1
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
  [./Pe]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./Ev]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./Pe_aux]
    type = LynxEffectivePressureAux
    variable = Pe
  [../]
  [./Ev_aux]
    type = LynxVolStrainAux
    variable = Ev
  [../]
[]

[BCs]
  [./no_ux]
    type = PresetBC
    variable = disp_x
    boundary = 'left'
    value = 0.0
  [../]
  [./no_uy]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  [../]
  [./no_uz]
    type = PresetBC
    variable = disp_z
    boundary = 'back'
    value = 0.0
  [../]
  [./load_ux]
    type = LynxVelocityBC
    variable = disp_x
    boundary = 'right'
    value = -1.0e-02
  [../]
  [./load_uy]
    type = LynxVelocityBC
    variable = disp_y
    boundary = 'top'
    value = -1.0e-02
  [../]
  [./load_uz]
    type = LynxVelocityBC
    variable = disp_z
    boundary = 'front'
    value = -1.0e-02
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
    petsc_options_value = 'gmres asm 1E-15 1E-10 20 50 ilu NONZERO'
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