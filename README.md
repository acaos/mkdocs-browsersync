# MkDocs + BrowserSync

<p align="center">
  <a href="https://hub.docker.com/r/acaos/mkdocs-browsersync">
    <img src="https://img.shields.io/docker/automated/acaos/mkdocs-browsersync">
  </a>
</p>

Due to [recent changes in MkDocs version 1.1.1](https://github.com/mkdocs/mkdocs/issues/2108), it is now less convenient to run MkDocs within a Docker for local development. In addition, the maintainer of MkDocs has stated that the libraries used to support serving and live reloading are poorly supported and may break in the future.

This repository attepts to offer an alternative solution, combining [MkDocs](https://github.com/mkdocs/mkdocs), [BrowserSync](https://github.com/BrowserSync/browser-sync), and [Gulp](https://github.com/gulpjs/gulp) into a single Docker container which will watch a volume, automatically rebuild on changes, and then refresh attached browsers. The documentation is built and then `rsync`ed to the final location to allow for a clean build that does not delete actively-served files while the build is in progress.

## Usage

Basic usage (from the directory with your `mkdocs.yml`):

```sh
docker run --rm -p 8080:8080 -v $(pwd):/docs -it acaos/mkdocs-browsersync:latest
```

If you are using the excellent [git-revision-date](https://github.com/zhaoterryy/mkdocs-git-revision-date-plugin) plugin and your `.git` directory is above your `mkdocs.yml`, you may need to specify the working directory as well (the example below assumes `project/mkdocs.yml`):

```sh
docker run --rm -p 8080:8080 -v $(pwd):/docs -w /docs/project -it acaos/mkdocs-browsersync:latest
```

## Configuration

The only additional configuration available is that a `MKDOCS_IGNORE` environment variable may be passed which specifies a space-separated list of globs to ignore when watching.

## Future Development

+ [ ] Inspect `mkdocs.yml` and build a better list of directories to watch rather than watching the entire working directory.
+ [ ] Allow more configuration of BrowserSync.
+ [ ] Add a sample `docker-compose.yml` for use with Docker Compose.
+ [ ] Add examples of more advanced usage (e.g. plugin integration, additional Gulp build steps).
+ [ ] Add examples for non-Dockerized usage.

.
