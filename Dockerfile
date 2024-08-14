FROM gibiansky/ihaskell:202402180200083d03fb
COPY --chown=jovyan notebooks/ /home/jovyan/src/
COPY --chown=jovyan config/ /home/jovyan/.jupyter/
EXPOSE 8888
CMD jupyter-lab --ip=0.0.0.0
