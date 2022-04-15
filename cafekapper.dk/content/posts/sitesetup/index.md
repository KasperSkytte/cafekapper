---
title: "How this site is automated"
date: 2022-04-13T19:14:29Z
draft: false
ShowToc: false
TocOpen: false
---

I had one primary condition when I decided to make a personal website: It must be absolutely painless to create new posts and publish them automatically through continuous integration. All I have to do is to push changes to a GitHub repository and things take care of themselves automatically.

## Bundling everything in a Docker container

Creating a simple [Docker container](https://www.docker.com/) to both serve and develop the [Hugo](https://gohugo.io/) website was my first thought. It just makes automation much easier, and it's portable so that I can work with it anywhere, and deployment is easily automated when creating new posts. I use [development containers](https://code.visualstudio.com/docs/remote/containers) through [Visual Studio Code](https://code.visualstudio.com/) quite often for scientific workflows and data science stuff (you should too), and it's straight forward to simply use a default [Hugo community](https://github.com/microsoft/vscode-dev-containers/tree/main/containers/hugo) docker image from the remote containers extension (just click `F1` -> `Add Development Container Configuration Files`), and add a few lines to the [`Dockerfile`](https://github.com/KasperSkytte/cafekapper.dk/blob/main/Dockerfile) to include the website.

![Adding configuration files for Hugo development container in VSCode](images/hugo_devcontainer.png)

I also chose the [PaperMod](https://adityatelange.github.io/hugo-PaperMod/) theme as a start, which is just included as a [git submodule](https://www.atlassian.com/git/tutorials/git-submodule). A nice feature of Hugo is that you can always just change the theme without having to adjust any content. It's all markdown, the content stays the same, it's just presented differently.

Once the container is started through VSCode previewing the site is easily done by running `hugo server` while inside the site directory. New posts can be created manually as markdown files or by using a default template with `hugo new posts/newpost.md`. Hugo rebuilds the site immediately when saving a file or when any other change to the contents of the folder is detected.

## Continuous integration

To build https://github.com/KasperSkytte/cafekapper.dk/actions/new

https://github.com/actions/starter-workflows/blob/main/ci/docker-publish.yml

Push to GitHub, and GitHub actions will rebuild container

## Site is automatically updated

SWAG + docker + watchtower

ouroboros/watchtower/diun