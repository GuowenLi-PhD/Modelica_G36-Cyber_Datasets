.. _SetUsecase:

Usecases
========
:numref:`fig-system-schematics` is a schematic drawing of a typical HVAC system for a medium office building. 
Heating and cooling are delivered by a single-duct VAV system. 
One AHU connected with five VAV terminal boxes serves five zones (four exterior zones and one interior zone) at one floor. 
The chilled water is supplied by a central chiller plant which consists of a chiller, a waterside economizer, a cooling tower, one chilled water pump, and one cooling water pump. 
A boiler, fed by natural gas, supplies the hot water to the AHU heating coils. 

.. _fig-system-schematics: 
.. figure:: /figures/system-schematics.pdf
    :width: 400pt
    :align: center

    Schematics of a typical HVAC system

A virtual BAS for the HVAC equipment and system, specified in :numref:`fig-system-schematics`, is designed and depicted in :numref:`fig-network-topology`. 
The building automation architecture and communications are divided into three distinct layers or levels of management, automation, and field devices. 
The advantage of such an architecture is that there is a clear separation of duties and a reduction of network traffic at the management level. 
The management level comprises operator stations, monitoring and operator units, programming units, and other computer devices connected to a data processing device, i.e., a server, to support the information exchange and management of the automation system. 
For this report, we focus on the programming units that provide a supervisory-level control for the whole system. 
The automation level is associated with controllers that serve the main plants, such as AHUs, chillers, boiler units, etc. 
These controllers are usually digital and based on microprocessors, such as a Programmable Logic Controller. 
The management level communicates with the automation level through a management network that uses the BACnet/IP protocol, which assumes that all the automation devices support BACnet communication protocol. 
The field level compromises devices that generally self-contained physical units, like actuators, sensors, valves, dampers, fans, etc. 
The field level devices communicate to the automation level through a field network via a hard-wired physical connection.

.. _fig-network-topology: 
.. figure:: /figures/network-topology.pdf
    :width: 400pt
    :align: center

    A communication network topology of the typical HVAC system for a commercial building

The supervisory control in the management level includes chilled water supply temperature (CHWST) reset control, chilled water different pressure (CHWDP) reset control, hot water supply temperature (HWST) reset control, hot water differential pressure (HWDP) reset control, condenser water supply temperature (CWST) reset control, supply air temperature (SAT) reset control, zone temperature reset control and on/off schedules for the plants.  
These schedules are sent to the automation level via the management network. 
A router is used to enable the communication between the BACnet/IP backbone network and the field networks. Once the automation level devices receive the schedules, they will calculate corresponding control actions based on the programmed logic.
For example, if the AHU controller with an assigned MAC address 240112 receives a SAT setpoint that is lower than its previous value, it may generate a control action that opens the cooling coil valve wider to reduce the SAT. 
The control action is sent to the field level cooling coil valve motor through the field network. 

For such a BACnet communication network, multiple vulnerabilities and threats have been identified through previous research :cite:`RN15,RN16`, including snooping, application service attacks, network layer attacks, and application layer attacks. 
This paper studies the application service attack such as data-intrusion attack where the attacker can manipulate the value of transmitted objects to disrupt building control system, and DoS attack on network and application layers where the attacker makes the transmission path unavailable in a targeted time period.

The modeling and simulation of threats in this section assume that a malicious attacker wants to attack the system and undermine the building service and grid service by compromising a number of control signals. The attacker has the following capabilities:
    - For each attack, the attacker only has limited information about the system topology and states. 
    - The attacker can choose which controller or sensor to attack.
    - The attacks can only happen at the management level of the communication network.

In this section, four threats are defined and simulated, as summarized in :numref:`tab-summary-threats`.
Threat 1 refers to a malicious change of the number of transmitted zone temperature reset requests at the supervisory level. 
Threat 2 manipulates the on/off signal of a chiller to represent a remote cyber-attack.
Threat 3 blocks chiller from receiving the chilled water supply temperature setpoint from the supervisory controller.
Threat 4 maliciously lower the global zone temperature cooling setpoint so that more power would be used by the system.
The four threats are injected in the on-peak period in order to observe signficant consequences of both building service and grid service.
The injection time and period are not the same so that different orders of threats can be modeled and simulated.

.. _tab-summary-threats:
.. csv-table:: Summary of Threats
   :file: tables/summary-threats.csv
   :class: longtable
   :widths: 10,15,10,10,10,10,35
   :align: center

There are in total fifteen simulation cases by combining these four threats with different active status.
:numref:`tab-summary-cases` summarizes the detailed active status of each threat for each case.
All cases are simulated for a hot summer day, when the chiller is activated to provide cooling to the building.

.. _tab-summary-cases:
.. csv-table:: Summary of Cases
   :file: tables/summary-cases.csv
   :class: longtable
   :widths: 10,10,10,10,10
   :align: center

.. _subsec-case1:

Case 1
-------
In this case, we assume an attack is launched on the AHU supply temperature reset control at the supervisory level by corrupting the number of transmitted zone temperature reset requests. In the fault-free baseline system, the maximum number of temperature reset requests for each zone is three if the zone temperature exceeds its setpoint by 1 °C. Therefore, during normal operation, the total number of temperature reset requests should always be no greater than 15 for five thermal zones. During the attack period, we corrupt the number of temperature reset requests to 15 all the time using the *Max Attack* model mentioned in :numref:`subsec_attacker`. The attack is injected from 12pm to 3pm. The system response under attack is simulated and evaluated in the proposed framework. 

:numref:`fig-case1-states` and :numref:`fig-case1-power` compare the responses of system states and power under attack-free and attack-injected situations in a day in the cooling season. Because the number of zone temperature reset requests is corrupted to its maximum value, the SAT reset controller responds to the fraudulent fact that the temperatures in the zones were too high and supply air with lower temperature should be supplied. However, in a hot day in the cooling season, the SAT setpoint is already at its minimum allowable value (12 °C). The control command that further reduces this setpoint cannot be executed, and the SAT setpoints in the attack-injected case stay the same as those in the attack-free baseline case. Therefore, in this attack, no impact can be observed in the system states and system power, which leads to an ineffective attack.

.. _fig-case1-states: 
.. figure:: /figures/case1-states.pdf
    :width: 400pt
    :align: center

    System states between case 1 and baseline

.. _fig-case1-power: 
.. figure:: /figures/case1-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 1 and baseline

Case 2
-------
This scenario simulates an attack that corrupts the chiller on/off control signal sent from the management level to the local chiller. The attack is injected from 12pm to 3pm on a typical day in the cooling season. The attacker injects a pulse wave signal to the chiller so that the chiller cycle on/off every 30 minutes as shown in :numref:`fig-case2-states`.

During the attack, the frequent activation and deactivation of the chiller leads to the oscillating system states. When the chiller is off for 30 minutes, the zone temperature and SAT increase due to the system’s inability to provide chilled water. To meet the ventilation requirement in the zones, the high temperature outdoor air is mixed with the zone return air, which leads to a higher SAT than the zone temperature when the cooling is unavailable. To maintain the zone temperature at its setpoint, the VAV damper opens at its minimum position to supply the minimum air to meet the zone’s ventilation needs. Thus, the supply fan only needs to run at a small speed to provide required minimum air flow. When the chiller is on after 30 minutes, all the equipment work harder to recover the deviated system states to normal conditions as soon as possible. However, in 30 minutes, the system cannot be fully recovered. For example, the SAT cannot be cooled down to its setpoint in 30 minutes when the chiller is on during the pulse attack as shown in :numref:`fig-case2-states`. This eventually causes escalating SAT deviations from its setpoint over the pulse attack period. The same escalating deviations also can be observed in the zone temperatures, VAV damper openings, and supply fan speed, etc. The oscillating system states consequentially result in the oscillating system power as shown in :numref:`fig-case2-power`.

During the post-attack period, the system spends significant efforts to recover from the deviations. As shown in :numref:`fig-case2-states`, the controller sets the CHWST to its minimum value to maximize the provision of cooling, the supply air fan operates at a high speed to blow cold air into the zones as much as possible. This eventually leads to significant power consumption of each major component as shown in :numref:`fig-case2-power`. The system almost operates at its full capacity at the beginning of the post-attack, and gradually decreases its output as the deviations of the system states decrease. In addition, different system states require different recovery times due to their specific inertia and the control system designs. For example, the zone temperature requires about 4 hours to get back to its setpoint, while the SAT only needs about 1.5 hours. All these observations can guide the design of threat mitigation techniques to avoid high power peak or large energy consumption after the pulse attack.

.. _fig-case2-states: 
.. figure:: /figures/case2-states.pdf
    :width: 400pt
    :align: center

    System states between case 2 and baseline

.. _fig-case2-power: 
.. figure:: /figures/case2-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 2 and baseline

Case 3
-------
This scenario simulates a cyber-attack launched on the transmission of CHWST setpoint from supervisory chilled water temperature reset controller to local chiller board. The CHWST is continuously reset from a minimum value of 5 °C to a maximum value of 10 °C. The attack aims to block the chiller from receiving the setpoint. The attack is initiated at 10am and lasts for 3 hours. Detailed system responses are shown in :numref:`fig-case3-states` and :numref:`fig-case3-power`.

During the attack period (10am-1pm), the baseline system gradually resets the CHWST from 7.5 °C at noon to around 5.5 °C in the afternoon because the cooling load in the building grows in the afternoon due to solar impact. The attack-injected system maintains the CHWST setpoint at 7.5 °C during the whole attack period due to the unavailability of communication paths. Therefore, the chiller only produces chilled water at 7.5 °C even when the cooling load is large in the afternoon, and the cooling coil valve has to fully open in response to a high CHWST, which triggers the re-generation of CHWST in the reset controller (**green dotted line in :numref:`fig-case3-states`**). However, the re-generated setpoint cannot reach  the local chiller because of signal blocking. Furthermore, the high CHWST results in high SAT. To maintain the zone temperature at the same setpoint of 24 °C, the VAV dampers open wider and the supply air fan increases its speed to deliver more air into the zones.

During the attack period, because of the higher CHWST, the chiller consumes less energy compared with the baseline system, which eventually results in less heat rejected in the cooling tower and thus less cooling tower fan power. However, the chilled water pump consumes more energy than the baseline system because higher CHWST requires more pump energy to deliver more chilled water through the cooling coil to maintain SAT. Moreover, the increased supply fan speed leads to increased fan power consumption.

During the post-attack period, the CHWST is reset relatively slower than in the baseline system, which results in lower CHWST in the attack-injected system. As a consequence, the chiller consumes more energy compared with that in the same period in the baseline system. The system as a whole consumes more energy to recover from the attack.

.. _fig-case3-states: 
.. figure:: /figures/case3-states.pdf
    :width: 400pt
    :align: center

    System states between case 3 and baseline

.. _fig-case3-power: 
.. figure:: /figures/case3-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 3 and baseline

Case 4
-------
This scenario simulates an active threats that lowers the global zone temperature cooling setpoint during on-peaks. 
The baseline cooling setpoint is 24 °C, and during the threatened period, the cooling setpoint is lowered to 22 °C. 
The attack is initiated at 1pm and lasts for 2 hours. Detailed system responses are shown in :numref:`fig-case4-states` and :numref:`fig-case4-power`.

During the threat period, the zone temperature setpoint for cooling is lowered from 24 °C to 22 °C, which increases the number of zone temperature reset requests as more cooling should be delivered to the zone.
However, as mentioned in :numref:`subsec-case1`, although the number of the zone temperature reset requests increases, the SAT setpoint cannot be further reduced because of its lower limit. 
The lower zone temperature cooling setpoint introduces extra cooling needs to the chiller.
Although the chiller controller has already reset its supply temperature setpoint to the lowest value (5.5 °C), due to the large cooling needs, the chiller cannot deliver chilled water to the AHU at the required temperature setpoint. 
Therefore, the SAT increases during the threat because of uncontrolleable CHWST.
Although the VAV terminal opens wider to introduce more air into the zone, the zone temperature still cannot be lowered to the setpoint of 22 °C.
The system eventually consumes more energy than the baseline during the threat due to the extra cooling needs handled by the chiller and its associated equipment (pumps, fan and cooling tower etc.).

During the post-threat period, the zone temperature setpoint recovers from 22 °C to 24 °C, but the system states requires more than 2 hours to recover to the baseline states.
During the recovery, the system consume more energy than baseline due to the deviated states.


.. _fig-case4-states: 
.. figure:: /figures/case4-states.pdf
    :width: 400pt
    :align: center

    System states between case 4 and baseline

.. _fig-case4-power: 
.. figure:: /figures/case4-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 4 and baseline

Case 5
-------
Case 5 simulates a combination of threat 1 and threat 2. 
Because threat 1 is ineffective under the supervisory control logic in Guideline 36 as mentioned in :numref:`subsec-case1`, this case has the same results as Case 2.

.. _fig-case5-states: 
.. figure:: /figures/case5-states.pdf
    :width: 400pt
    :align: center

    System states between case 5 and baseline

.. _fig-case5-power: 
.. figure:: /figures/case5-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 5 and baseline

Case 6
-------
Case 6 simulates a combination of threat 1 and threat 3. 
Because threat 1 is ineffective under the supervisory control logic in Guideline 36 as mentioned in :numref:`subsec-case1`, this case has the same results as Case 3.

.. _fig-case6-states: 
.. figure:: /figures/case6-states.pdf
    :width: 400pt
    :align: center

    System states between case 6 and baseline

.. _fig-case6-power: 
.. figure:: /figures/case6-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 6 and baseline

Case 7
-------
Case 7 simulates a combination of threat 1 and threat 4. 
Because threat 1 is ineffective under the supervisory control logic in Guideline 36 as mentioned in :numref:`subsec-case1`, this case has the same results as Case 4.

.. _fig-case7-states: 
.. figure:: /figures/case7-states.pdf
    :width: 400pt
    :align: center

    System states between case 7 and baseline

.. _fig-case7-power: 
.. figure:: /figures/case7-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 7 and baseline

Case 8
-------
Case 8 simulates a combination of threat 2 and threat 3. 

.. _fig-case8-states: 
.. figure:: /figures/case8-states.pdf
    :width: 400pt
    :align: center

    System states between case 8 and baseline

.. _fig-case8-power: 
.. figure:: /figures/case8-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 8 and baseline

Case 9
-------
Case 9 simulates a combination of threat 2 and threat 4. 

.. _fig-case9-states: 
.. figure:: /figures/case9-states.pdf
    :width: 400pt
    :align: center

    System states between case 9 and baseline

.. _fig-case9-power: 
.. figure:: /figures/case9-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 9 and baseline

Case 10
-------
Case 10 simulates a combination of threat 3 and threat 4. 

.. _fig-case10-states: 
.. figure:: /figures/case10-states.pdf
    :width: 400pt
    :align: center

    System states between case 10 and baseline

.. _fig-case10-power: 
.. figure:: /figures/case10-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 10 and baseline

Case 11
-------
Case 11 simulates a combination of threat 1, threat 2 and threat 3, which has the same results as case 8. 

.. _fig-case11-states: 
.. figure:: /figures/case11-states.pdf
    :width: 400pt
    :align: center

    System states between case 11 and baseline

.. _fig-case11-power: 
.. figure:: /figures/case11-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 11 and baseline

Case 12
-------
Case 12 simulates a combination of threat 1, threat 2 and threat 4, which has the same results as case 9.
 
.. _fig-case12-states: 
.. figure:: /figures/case12-states.pdf
    :width: 400pt
    :align: center

    System states between case 12 and baseline

.. _fig-case12-power: 
.. figure:: /figures/case12-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 12 and baseline

Case 13
-------
Case 13 simulates a combination of threat 1, threat 3 and threat 4, which has the same results as case 10. 

.. _fig-case13-states: 
.. figure:: /figures/case13-states.pdf
    :width: 400pt
    :align: center

    System states between case 13 and baseline

.. _fig-case13-power: 
.. figure:: /figures/case13-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 13 and baseline

Case 14
-------
Case 14 simulates a combination of threat 2, threat 3 and threat 4.

.. _fig-case14-states: 
.. figure:: /figures/case14-states.pdf
    :width: 400pt
    :align: center

    System states between case 14 and baseline

.. _fig-case14-power: 
.. figure:: /figures/case14-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 14 and baseline

Case 15
-------
Case 15 simulates a combination of threat 1, threat 2, threat 3 and threat 4, which has the same results as case 14.

.. _fig-case15-states: 
.. figure:: /figures/case15-states.pdf
    :width: 400pt
    :align: center

    System states between case 15 and baseline

.. _fig-case15-power: 
.. figure:: /figures/case15-power.pdf
    :width: 400pt
    :align: center

    System power comparison between case 15 and baseline