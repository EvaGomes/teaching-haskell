FROM gibiansky/ihaskell
COPY notebooks/ /home/jovyan/src/
EXPOSE 8888
CMD jupyter-lab --ip=0.0.0.0
