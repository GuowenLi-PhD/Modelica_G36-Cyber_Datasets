# Settings
Singal delaying is lauched at supervsory-level controller. The delayed signal is chilled water temperature setpoint calculated from the supervisory controller and transmitted to chiller board.

The simulation is performed during a cooling season on day 207. The attack is injected at 12:00pm to 6:00pm. During the attack, the signal is delayed 30 minutes from supervisory controller to local chiller.

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