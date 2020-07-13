# development-container

Scripts and a Dockerfile for building and running a open-source code
development container.

The container is meant for interactive development.

# Docker Image

* base: ubuntu focal
* language toolchains:
    * python3
    * rust
    * Java jdk11
* personal dotfiles setup
* `oss-workspace` as a mounted FS for persisting repositories
* language caches are not persisted
