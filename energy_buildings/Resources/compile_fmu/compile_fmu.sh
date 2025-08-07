  exec docker run \
 	  --name fr_test \
          --user=root \
	  --detach=false \
	  -e DISPLAY=${DISPLAY} \
	  -v /tmp/.X11-unix:/tmp/.X11-unix\
	  --rm \
	  -v `pwd`:/mnt/shared \
	  -i \
          -t \
	  modelica_fault /bin/bash -c "cd /mnt/shared && python /mnt/shared/compile_fmu.py"
    exit $
