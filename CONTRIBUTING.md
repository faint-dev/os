# Contributing to Zog

Thanks for your interest in contributing! Here's how to help.

## Reporting Issues

1. Check [GitHub Issues](https://github.com/faint-dev/os/issues) (may already be reported)
2. Click "New Issue"
3. Title: Brief description (e.g., "Wi-Fi drops after suspend")
4. Description:
   - What happened
   - Steps to reproduce
   - Expected vs actual behavior
   - System info: `inxi -Fxz`
5. Click "Submit"

## Contributing Code

### Setup

```bash
git clone https://github.com/faint-dev/os.git
cd os
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Make Changes

1. Create a branch: `git checkout -b fix/my-fix` or `git checkout -b feature/my-feature`
2. Edit files (see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for structure)
3. Test locally: `make iso` (or `make iso-docker` on macOS)
4. Commit: `git commit -m "Clear message describing change"`
5. Push: `git push origin fix/my-fix`
6. Open a Pull Request on GitHub

### Areas to Contribute

- **Packages**: Add/remove packages in `archiso/packages/*.txt`
- **Theming**: Improve KDE/Hyprland themes in `theming/`
- **Docs**: Fix typos or expand guides in `docs/`
- **Scripts**: Improve build/release scripts in `scripts/`
- **Calamares**: Enhance installer config in `archiso/airootfs/etc/calamares/`
- **CI/CD**: Improve GitHub Actions workflows in `.github/workflows/`

### Code Style

- Shell scripts: Follow [shellcheck](https://www.shellcheck.net) (run `shellcheck scripts/*.sh`)
- YAML: 2-space indentation
- Documentation: Clear, concise, spell-checked

## Themes & Artwork

Want to contribute a theme?

1. Create a directory in `theming/`
2. Include:
   - Screenshots (PNG)
   - `README.md` with description
   - Theme files (KDE color schemes, Hyprland configs, etc.)
3. Submit a PR

## Release Process

To release a new version:

```bash
scripts/release.sh 1.0.1  # Creates git tag v1.0.1
# GitHub Actions automatically builds + publishes
```

## Code of Conduct

- Be respectful and inclusive
- No harassment or discrimination
- Welcome all skill levels
- Focus on the work, not the person

## License

All contributions are under GPL-3.0. See [LICENSE](LICENSE).

---

Thanks for contributing! 🎉
