# Docker-Compose Files
- Check templates/compose-* upstream Docker Compose files; each file references its source. When the upstream docker-compose file changes, the corresponding template in templates/ needs to be updated as well.
- Update `docker_apt_repository` to latest Debian in [meta/main.yaml](meta/main.yaml)