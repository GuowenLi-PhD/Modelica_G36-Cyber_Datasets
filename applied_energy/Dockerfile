#FROM michaelwetter/ubuntu-1604_jmodelica_trunk
FROM yangyangfu/fncs:modelica
######################
# FR DC Docker
######################

USER root
RUN pip install pandas

#################################
## copy folders
############################
COPY Buildings /usr/local/JModelica/ThirdParty/MSL/Buildings
