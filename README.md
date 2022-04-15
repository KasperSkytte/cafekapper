# cafekapper.dk

Repository with source code for my website https://cafekapper.dk. Built and served using <https://gohugo.io/> with the [PaperMod theme](https://github.com/adityatelange/hugo-PaperMod/).

- Clone recursively, or if you forgot to do so run `git submodule update --init --recursive --remote` afterwards.
- Develop in Dev Container through VSCode. Start website preview with `hugo server -D`, access at <http://localhost:1313/>.
- Add new posts from template with `hugo new posts/name.md`.
- Remember to set `draft: false` in preamble of posts to publish.

To serve the site use `docker run -p 1313:1313 ghcr.io/kasperskytte/cafekapper.dk:latest` and it will be available at `http://localhost:1313`.
