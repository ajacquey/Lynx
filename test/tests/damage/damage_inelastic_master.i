[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 10
  ny = 10
  xmin = 0
  xmax = 1
  ymin = 0
  ymax = 1
[]

[Variables]
  [./disp_x]
  [../]
  [./disp_y]
  [../]
[]

[Kernels]
  [./mech_x]
    type = LynxSolidMomentum
    variable = disp_x
    component = 0
    displacements = 'disp_x disp_y'
  [../]
  [./mech_y]
    type = LynxSolidMomentum
    variable = disp_y
    component = 1
    displacements = 'disp_x disp_y'
  [../]
[]

[AuxVariables]
  [./damage]
    order = FIRST
    family = LAGRANGE
  [../]
  [./damage_rate]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./mises_stress]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./pressure]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./eqv_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./eqv_in_strain]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./eqv_in_strain_rate]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[AuxKernels]
  [./damage_rate_aux]
    type = MaterialRealAux
    variable = damage_rate
    property = damage_rate
    execute_on = 'timestep_end'
  [../]
  [./mises_stress_aux]
    type = LynxVonMisesStressAux
    variable = mises_stress
    execute_on = 'timestep_end'
  [../]
  [./pressure_aux]
    type = LynxEffectivePressureAux
    variable = pressure
    execute_on = 'TIMESTEP_END'
  [../]
  [./eqv_strain_aux]
    type = LynxEqvStrainAux
    variable = eqv_strain
    execute_on = 'timestep_end'
  [../]
  [./eqv_in_strain_aux]
    type = LynxEqvStrainAux
    variable = eqv_in_strain
    strain_type = plastic
    execute_on = 'timestep_end'
  [../]
  [./eqv_in_strain_rate_aux]
    type = LynxEqvStrainRateAux
    variable = eqv_in_strain_rate
    strain_type = plastic
    execute_on = 'timestep_end'
  [../]
[]

[BCs]
  [./no_ux]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]
  [./ux_right]
    type = LynxVelocityBC
    variable = disp_x
    boundary = right
    value = -1.0e-14
  [../]
  [./uy_top]
    type = LynxVelocityBC
    variable = disp_y
    boundary = top
    value = 1.0e-14
  [../]
  [./no_uy]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]
[]

[Materials]
  [./deformation]
    type = LynxDamageDeformation
    displacements = 'disp_x disp_y'
    damage = 'damage'
    bulk_modulus = 1.0e+10
    shear_modulus = 1.0e+10
    damage_modulus = 0.5e+10
    friction_angle = 30
    cohesion = 10.0e+06
    plastic_viscosity = 1.0e+22
    damage_viscosity = 1.0e+19
  [../]
[]

[MultiApps]
  [./sub]
    type = TransientMultiApp
    input_files = 'damage_inelastic_sub.i'
    execute_on = 'TIMESTEP_END'
    sub_cycling = true
    detect_steady_state = true
    steady_state_tol = 1.0e-8
  [../]
[]

[Transfers]
  # To the multi app
  [.damage_rate_to_sub]
    type = MultiAppCopyTransfer
    source_variable = damage_rate
    variable = damage_rate
    direction = to_multiapp
    multi_app = sub
    execute_on = SAME_AS_MULTIAPP
  [../]
  # From the Multi app
  [./damage_from_sub]
    type = MultiAppCopyTransfer
    source_variable = damage
    variable = damage
    direction = from_multiapp
    multi_app = sub
    execute_on = SAME_AS_MULTIAPP
  [../]
[]
  
[Postprocessors]
  [./D]
    type = ElementAverageValue
    variable = damage
    outputs = csv
  [../]
  [./Se]
    type = ElementAverageValue
    variable = mises_stress
    outputs = csv
  [../]
  [./P]
    type = ElementAverageValue
    variable = pressure
    outputs = csv
  [../]
  [./E_eqv]
    type = ElementAverageValue
    variable = eqv_strain
    outputs = csv
  [../]
  [./E_in_eqv]
    type = ElementAverageValue
    variable = eqv_in_strain
    outputs = csv
  [../]
  [./E_dot_in_eqv]
    type = ElementAverageValue
    variable = eqv_in_strain_rate
    outputs = csv
  [../]
[]

[Preconditioning]
  [./precond]
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-ksp_type -snes_atol -snes_rtol -snes_max_it -ksp_max_it
                           -pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold
                           -pc_hypre_boomeramg_agg_nl -pc_hypre_boomeramg_agg_num_paths
                           -pc_hypre_boomeramg_max_levels
                           -pc_hypre_boomeramg_coarsen_type -pc_hypre_boomeramg_interp_type
                           -pc_hypre_boomeramg_P_max -pc_hypre_boomeramg_truncfactor
                           -snes_linesearch_type'
    petsc_options_value = 'fgmres 1.0e-00 1.0e-10 1000 100
                           hypre boomeramg 0.7
                           4 5
                           25
                           HMIS ext+i
                           2 0.3
                           basic'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  start_time = 0.0
  end_time = 3.1536e+11
  dt = 6.3072e+09
[]

[Outputs]
  execute_on = 'timestep_end'
  print_linear_residuals = false
  perf_graph = true
  exodus = true
  csv = true
[]
