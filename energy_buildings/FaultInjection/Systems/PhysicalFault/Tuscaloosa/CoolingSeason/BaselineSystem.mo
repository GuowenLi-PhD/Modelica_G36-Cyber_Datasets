within FaultInjection.Systems.PhysicalFault.Tuscaloosa.CoolingSeason;
model BaselineSystem
  extends FaultInjection.Systems.PhysicalFault.Chicago.CoolingSeason.BaselineSystem(
          weaDat(filNam=ModelicaServices.ExternalReferences.loadResource(
          "modelica://Buildings/Resources/weatherdata/USA_AL_Tuscaloosa.Muni.AP.722286_TMY3.mos")),
          flo(conExtWal(nLay=4, each material={flo.matWoo,flo.matGyp,flo.matIns,flo.matGyp}),
              matWoo(x=0.0254,k=0.72,c=840,d=1856),
              matGyp(x=0.0159,k=0.16,c=1090,d=800)),
          occSch(occupancy=3600*{7,19}),
          designCoolLoad = -1.2*m_flow_nominal*1000*15,
          designHeatLoad = 0.3*m_flow_nominal*1006*(18 - 8));

  annotation (experiment(
      StartTime=16934400,
      StopTime=17539200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="modelica://FaultInjection/Resources/Scripts/dymola/Systems/PhysicalFault/Tuscaloosa/CoolingSeason/BaselineSystem.mos"
        "Simulate and Plot"));
end BaselineSystem;
