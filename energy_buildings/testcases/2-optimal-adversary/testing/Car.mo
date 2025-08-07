within ;
package Car
  model RaceCar "Race car"

    Modelica.Blocks.Interfaces.RealInput acceleration
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput position(start=0)
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealOutput velocity(start=0)
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  equation

    der(position) = velocity;
    der(velocity) = acceleration - velocity;

    annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-152,152},{148,112}},
          textString="%name",
          lineColor={0,0,255})}),                                  Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end RaceCar;

  model testRaceCar
    extends Modelica.Icons.Example;

    RaceCar car
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Modelica.Blocks.Sources.Step step(
      height=-0.5,
      offset=1,
      startTime=1)
      annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  equation
    connect(step.y, car.acceleration)
      annotation (Line(points={{-59,0},{-12,0}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(StopTime=2, __Dymola_Algorithm="Dassl"));
  end testRaceCar;
  annotation (uses(Modelica(version="3.2.3")));
end Car;
