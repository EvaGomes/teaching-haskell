# Syntax Highlighting issue

Somewhere during school year 2023/2024, I noticed that instances of [JupyterLab] in [BinderHub] no longer highlighted
syntax of the IHaskell notebooks (no coloring in the code cells).

Today I spent long hours searching the internet for people reporting similar issues while using the docker image
[gibiansky/ihaskell], or IHaskell notebooks in [JupyterLab], or CodeMirror issues.

## Experience on trying to solve this

- I found only one GitHub issue published in the last months related to a syntax highlighting problem: [issue #1488] of
  26 April 2024 in the [IHaskell repo], named *«Syntax highlight not working with jupyterlab 4.1.6»*.
  It had little info and got closed in June due to inactivity.

NOTHING HELPFUL THERE... DIGGING GOES ON

- From a [comment](https://github.com/IHaskell/IHaskell/issues/1120#issuecomment-554995997) to an older issue ([issue
  #1120]), I got to know that JupyterLabs in [gibiansky/ihaskell]s Docker containers use a JupyterLab extension named
  [jupyterlab-ihaskell] to do the syntax highlighting of IHaskell notebooks.

- As I couldn't see this extension in JupyterLab's `Advanced settings editor`, I tried to install it explicitly. I
  opened the Docker container's shell and tried running command `jupyter labextension install jupyterlab-ihaskell` (as
  stated in the [jupyterlab-ihaskell] extension's [README.md
  file](https://github.com/IHaskell/IHaskell/blob/master/jupyterlab-ihaskell/README.md)).

- It failed. The output showed a table in which we could see that this extension relied on version `>=4.0.0` of 4 other
  JupyterLab extensions, but that version-range was incompatible with the version-rage needed by the JupyterLab
  installed in the container...

DEAD END (until some hours later)

- I stumbled upon several issues about syntax highlighting on [jupyterlab-ihaskell] GitHub repository, but they
  pre-dated 2022. They were only important because I got to know that the text editor used in for cells and file editors
  of JupyterLab is [CodeMirror].

- Then, I found [issue #1419] of 25 Oct 2024 on the [jupyterlab-ihaskell] repo, named `jupyterlab-ihaskell does not
  support JupyterLab 4.x`. This immediately seemed related to my issue, because 2 links in the issue's description
  mentioned [CodeMirror]. I discovered that [JupyterLab v4] was released on June 2023 and that, in this major version
  bump, [CodeMirror] has been upgraded (to v6).

In my Dockerfile, I had not locked the version of the base Docker image [gibiansky/ihaskell], so I was using the latest
image available ([tagged 20240616021118d74aae]). From this point on, I assumed my problem was *«I have a Docker
container with JupyterLab v4 installed plus an incompatible version of the extension [jupyterlab-ihaskell]»*.

- First attempt to solve [issue #1419], i.e., to make [jupyterlab-ihaskell] compatible with JupyterLab v4, seems to be
  [commit 0d647a9] on April 21st, 2024  ([PR 1426]).

- In this commit, we see changes to file `package.json`: version bumps to dependencies of `jupyterlab-ihaskell`, to
  **">=4.0.0"**.

👀 I'd seen this range before!!! When I tried to explicitly install `jupyterlab-ihaskell` in the container... and it
failed because it was incompatible with the installed JupyterLab... What JupyterLab version am I working on then?!

- I opened `About JupyterLab` from JupyterLab's tab `Help` and, to my surprise, JupyterLab's version was still
  `3.6.7`... not v4.

If the Docker image is still using the old version of JupyterLab, why did problems start to happen? Had the
`jupyterlab-ihaskell` extension stopped being installed? Had it been upgraded to the newest version, becoming
incompatible with the older Lab?

- I eventually came to open the Developer Tools (because I had seen a post suggesting that some errors get print to the
  browser console when launching JupyterLab) and find the warning `jupyterlab-ihaskell@0.0.14 is not compatible with the
  current JupyterLab`.

- A little after, I realised that the Dockerfile (declaration file of [gibiansky/ihaskell]) is part of the exact same
  [repo](https://github.com/IHaskell/IHaskell) as the `jupyterlab-ihaskell` source code.

- The last piece: I check the Dockerfile of [gibiansky/ihaskell] and found out that the way the `jupyterlab-ihaskell`
  extension gets installed is by simply copying whichever code is in the extension's directory of the repo into the
  expected directory of the Docker container. This behavior was already defined for version v3 and had not changed.

**In conclusion**, the latest Docker images of [gibiansky/ihaskell] continue to install a JupyterLab v3 while installing
the most recent version of its extension `jupyterlab-ihaskell` (which is incompatible with v3, meant to be compatible
with v4)...

I don't know how to fix this... Best I can do is lock the version of my base Docker image to an older stable version...

- I manually tested 11 [gibiansky/ihaskell] Docker images... 😥

    - The lastest image where syntax highlighting works is [tagged 202402180200083d03fb].
    - Images from April 21st on do not have syntax highlighting.
    - Some images, like [tagged 2024030305323389ef54], don't even launch JupyterLab at all.
    - The latest image available in DockerHub at the moment, [tagged 20240616021118d74aae], is of June 16.

Why is no one else complaining about this?? I don't know. 🤷🏻‍♀️

---

[BinderHub]: https://binderhub.readthedocs.io

[JupyterLab]: https://jupyterlab.readthedocs.io/en/stable/index.html

[gibiansky/ihaskell]: https://hub.docker.com/r/gibiansky/ihaskell

[IHaskell repo]: https://github.com/IHaskell/IHaskell

[jupyterlab-ihaskell]: https://github.com/IHaskell/IHaskell/blob/master/jupyterlab-ihaskell/README.md

[JupyterLab v4]: https://jupyterlab.readthedocs.io/en/stable/getting_started/changelog.html#v4-0

[CodeMirror]: https://codemirror.net

[issue #1488]: https://github.com/IHaskell/IHaskell/issues/1488

[issue #1120]: https://github.com/IHaskell/IHaskell/issues/1120

[issue #1419]: https://github.com/IHaskell/IHaskell/issues/1419

[commit 0d647a9]: https://github.com/IHaskell/IHaskell/commit/0d647a9

[PR 1426]: https://github.com/IHaskell/IHaskell/pull/1426

[tagged 202402180200083d03fb]: https://hub.docker.com/layers/gibiansky/ihaskell/202402180200083d03fb/images/sha256-ca2e48277a4ac59dbc383d98a0bbe90186f4c1c32cd91e91b6f8f8a6d7d84caa

[tagged 2024030305323389ef54]: https://hub.docker.com/layers/gibiansky/ihaskell/2024030305323389ef54/images/sha256-d5a20c681fb5537e05ed128a190eddf29db75c16d14f75c58d93d0dc4946ee36

[tagged 20240616021118d74aae]: https://hub.docker.com/layers/gibiansky/ihaskell/20240616021118d74aae/images/sha256-913497d54ef3dfb2e3d0e6db933b44780a214f0ea9a684f5b19a6efd8e86a4cc
