FROM gibiansky/ihaskell
COPY notebooks/ /home/jovyan/src/
COPY config/ /home/jovyan/.jupyter/
EXPOSE 8888
CMD jupyter-lab --ip=0.0.0.0
