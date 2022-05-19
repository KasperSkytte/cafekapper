# cafekapper.dk

Repository with source code for my website https://cafekapper.dk. Built and served using <https://gohugo.io/> with the [PaperMod theme](https://github.com/adityatelange/hugo-PaperMod/).

To serve the site use `docker run -p 1313:1313 ghcr.io/kasperskytte/cafekapper.dk:latest`, will be available at <http://localhost:1313>.

- Clone recursively, or if you forgot to do so run `git submodule update --init --recursive --remote` afterwards.
- `cd cafekapper.dk/`
- Develop in Dev Container through VSCode. Start website preview with `hugo server -D`, access at <http://localhost:1313/>.
- Add new posts from template with `hugo new posts/name.md`.
- Remember to set `draft: false` in preamble of posts to publish.
