[Mesh]
  type = GeneratedMesh
  dim = 3
  nx = 4
  ny = 4
  nz = 4
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
  zmin = 0
  zmax = 1
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
[]

[Kernels]
  [./mech_x]
    type = LynxSolidMomentum
    variable = disp_x
    component = 0
  [../]
  [./mech_y]
    type = LynxSolidMomentum
    variable = disp_y
    component = 1
  [../]
  [./mech_z]
    type = LynxSolidMomentum
    variable = disp_z
    component = 2
  [../]
[]

[AuxVariables]
  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./plastic_strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pressure]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./sigma_e]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./yield]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./intnl]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./strain_xx_aux]
    type = LynxStrainAux
    variable = strain_xx
    index_i = 0
    index_j = 0
  [../]
  [./plastic_strain_xx_aux]
    type = LynxStrainAux
    variable = plastic_strain_xx
    strain_type = plastic
    index_i = 0
    index_j = 0
  [../]
  [./pressure_aux]
    type = LynxEffectivePressureAux
    variable = pressure
  [../]
  [./sigma_e_aux]
    type = LynxVonMisesStressAux
    variable = sigma_e
  [../]
  [./yield_aux]
    type = MaterialRealAux
    variable = yield
    property = plastic_yield_function
  [../]
  [./intnl_aux]
    type = LynxEqvStrainAux
    variable = intnl
    strain_type = plastic
  [../]
[]

[BCs]
  [./no_x_left]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./load_x_right]
    type = LynxVelocityBC
    variable = disp_x
    boundary = right
    value = -1.0e-05
  [../]
  [./no_y]
    type = PresetBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  [../]
  [./no_z_back]
    type = PresetBC
    variable = disp_z
    boundary = 'back'
    value = 0.0
  [../]
[]

[Materials]
  [./elastic_mat]
    type = LynxDeformation
    bulk_modulus = 2.0e+03
    shear_modulus = 2.0e+03
    friction_angle = 0.0
    cohesion = 0.5773502692
  [../]
[]

[Postprocessors]
  [./u_x]
    type = SideAverageValue
    variable = disp_x
    boundary = right
    outputs = csv
  [../]
  [./P]
    type = ElementAverageValue
    variable = pressure
    outputs = csv
  [../]
  [./Se]
    type = ElementAverageValue
    variable = sigma_e
    outputs = csv
  [../]
  [./Intl]
    type = ElementAverageValue
    variable = intnl
    outputs = csv
  [../]
  [./F]
    type = ElementAverageValue
    variable = yield
    outputs = csv
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold -pc_hypre_boomeramg_agg_nl -pc_hypre_boomeramg_agg_num_paths -pc_hypre_boomeramg_max_levels -pc_hypre_boomeramg_coarsen_type -pc_hypre_boomeramg_interp_type -pc_hypre_boomeramg_P_max -pc_hypre_boomeramg_truncfactor -snes_atol'
    petsc_options_value = 'hypre boomeramg 0.7 4 5 25 HMIS ext+i 2 0.3 1.0e-08'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  end_time = 100.0
  dt = 5.0
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = true
  perf_graph = true
  exodus = true
  csv = true
[]
