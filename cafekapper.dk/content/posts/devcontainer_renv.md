---
title: "How and why I do R projects within a development container"
date: 2023-07-21T10:23:03Z
draft: false
ShowToc: false
TocOpen: false
tags: ["docker", "renv", "devcontainer", "R"]
---

When doing many different projects and analyses involving R it's always a struggle keeping track of R package versions and the version of R itself. Often you'll see yourself returning to an old project somewhere, maybe on a different computer, or passing on your code to/from someone else. The required R packages are hopefully listed at the top of the R script or R markdown file so that it's clear which ones have been used throughout the code. But R by default will just install the most recent versions available for the particular major R version you're currently running and so you end up with many different versions across computers. This leads to problems because some functionality is likely different between different versions. Furthermore, some, usually older, versions of packages may not even be available for the particular version of R. So in order to run the code you'll have to install an older version of R, perhaps also remove the current R install (if you even have the permissions to do so), wait for R to install all the R packages yet again. It's honestly not a pleasant experience. I like brewing a cup of coffee to kill waiting times, but not several times a day.

## Development containers with VSCode
A good solution to allow both portability and reproducibility is to use the versioned Docker container images for R provided by the [rocker-project](https://rocker-project.org/). By developing inside a Docker container you can pull any version of R and start working without having to bother installing it whereever you are. All you need is Docker. Personally, I don't use RStudio anymore for R work partly because of this. I purely use Visual Studio Code, which I find just as good for R, and it's just more convenient with only one editor when also using other languages on a regular basis. In order to develop inside a Docker container you can use the [Dev containers](https://code.visualstudio.com/docs/devcontainers/containers) extension that spins up a Docker container of choice and connects it with VSCode. In combination with the [remote - SSH extension](https://code.visualstudio.com/docs/remote/ssh) it's so easy to work anywhere without the hassle of installing things over and over again. Just connect and pull a container. Everything's identical except the hardware.

## Using the host renv R library cache inside an devcontainer
For R projects, I always use the [renv](https://rstudio.github.io/renv/index.html) R package, which is analogous to Pythons [pipenv](https://pypi.org/project/pipenv/) package and others, that records the exact versions of R packages used in a project in a `renv.lock` file. It's really a good habit to get into, saving lots of time in the long run, and collaborators will love you for it. It works like a charm normally, but when using it in combination with a development container you'll still have to wait for R packages to install every time you (re)build the image. R is notoriously slow in that regard. Surely, you could upload a `Dockerfile` to a GitHub repo and let Actions build the container for you to pull, but that doesn't save you time here and now, and chances are you've used many of the same packages across projects before, seeming like a waste of time. Utilizing renv's [caching](https://rstudio.github.io/renv/articles/package-install.html?q=cache#cache) feature then becomes handy, but in order to make full use of it when developing inside a container, the cache must be mounted from the host to be available inside the container. An article [here](https://rstudio.github.io/renv/articles/docker.html) describes how to do it by setting a few environment variables. With development containers for VSCode though, it's best not to fiddle with `Dockerfile`s if you can and instead use the promade images, because they have some extra things included that allow proper support for VSCode. So my solution is to place this simple [.devcontainer/devcontainer.json](https://code.visualstudio.com/docs/devcontainers/containers#_create-a-devcontainerjson-file) file in the root of the project folder, which will expose a cache folder located in the home folder on the host to the container. Simply choose an R version, and ensure an `renv.lock` file is present in the project folder or create it afterwards. Cheers.

```json
// For format details, see https://aka.ms/devcontainer.json. For config options, see the
// README at: https://github.com/rocker-org/devcontainer-templates/tree/main/src/r-ver
{
  "name": "R (4.3)",
  "image": "ghcr.io/rocker-org/devcontainer/r-ver:4.3",
  "postCreateCommand": "R -q -e 'install.packages('renv'); renv::consent(provided = TRUE); renv::restore(prompt = FALSE)'",
  "remoteEnv": {
    "RENV_PATHS_CACHE": "/renv/cache"
  },
  "mounts": [
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.cache/R/renv/cache/,target=/renv/cache,type=bind"
  ]
}
```
