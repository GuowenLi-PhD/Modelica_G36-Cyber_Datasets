# Settings
Singal corruption is lauched at supervsory-level controller. The corrupted signal is zone temperature readings by AHU supply air temperature reset controller and zone temperature reset requests sent from VAV terminal boxes.

The simulation is performed during a shoulder season on day 83. The corruption is injected at 12:00pm to 3:00pm. 

# Requirements
- Dymola on Windows OS

# Steps

- Step 1: generate Dymola `.fmu` for both baseline system and signal corruption, and save `.fmu` to this folder.
  - baseline system: generate from `FaultInjection.Systems.CyberAttack.ShoulderSeason.BaselineSystem`.
  - signal corruption: generate from `FaultInjection.Systems.CyberAttack.ShoulderSeason.Scenario1_SignalCorruption`

- Step 2: pertubate models for upward and downward flexibility
  - baseline system: run `simulate_fmu_base.py`. Power profiles are saved in `power_base_pert.csv`.
  - attack mode: run `simulate_fmu_attack.py`. Power profiles are saved in `power_attack_pert.csv`.

- Step 3: calculate demand flexibility over an hour using `calculate_df.py`.