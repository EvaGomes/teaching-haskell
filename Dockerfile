FROM gibiansky/ihaskell:202402180200083d03fb
COPY --chown=jovyan notebooks/ /home/jovyan/src/
COPY --chown=jovyan config/ /home/jovyan/.jupyter/
EXPOSE 8888
CMD jupyter-lab --ip=0.0.0.0

# BUILD:      docker build -t ensico-jl-di-comp1 .
# LAUNCH CI:  docker run --rm -it -p 8888:8888 --name ensico-jl-dc-comp1 ensico-jl-di-comp1
# LAUNCH DEV: docker run --rm -it -p 8888:8888 -v $PWD/config:/home/jovyan/.jupyter -v $PWD/notebooks:/home/jovyan/src --name ensico-jl-dc-comp1 ensico-jl-di-comp1
