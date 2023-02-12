FROM gibiansky/ihaskell
COPY index.ipynb /home/jovyan/src/index.ipynb
EXPOSE 8888
CMD jupyter-lab --ip=0.0.0.0
