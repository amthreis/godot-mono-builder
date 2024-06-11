### Godot Mono Builder

Image with a Linux headless builder for Godot 4.x, used to automate Godot Engine builds. The engine is located at usr/local/bin and the templates are installed in /root/.local/share/godot/export_templates.

# How To Use

Building the source image is as simple as doing a `docker compose build` or `docker compose up --build` after cloning it.

Instructions to build a project with it are in the 2 .example files. Drop these files at the root folder of your game's project and run `docker compose -f compose.example up --build` if you are to keep their current names.