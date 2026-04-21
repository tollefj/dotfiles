#!/usr/bin/env python3
"""Copy skill folders from plugins/local submodules into this skills directory.

A skill folder is any directory that directly contains a SKILL.md file.
Existing destinations are replaced on each run.
"""

import shutil
from pathlib import Path

PLUGINS_LOCAL = Path(__file__).resolve().parent.parent / "plugins" / "local"
SKILLS_DIR = Path(__file__).resolve().parent


def find_skill_dirs(base: Path) -> list[Path]:
    return [p.parent for p in base.rglob("SKILL.md")]


def sync_skills() -> None:
    skill_dirs = sorted(find_skill_dirs(PLUGINS_LOCAL), key=lambda p: p.name)

    if not skill_dirs:
        print(f"No SKILL.md files found under {PLUGINS_LOCAL}")
        return

    for skill_dir in skill_dirs:
        dest = SKILLS_DIR / skill_dir.name
        if dest.exists():
            shutil.rmtree(dest)
        shutil.copytree(skill_dir, dest)
        source_rel = skill_dir.relative_to(PLUGINS_LOCAL)
        print(f"{source_rel} -> {dest.relative_to(SKILLS_DIR)}")


if __name__ == "__main__":
    sync_skills()
