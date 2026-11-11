# Source baseline

- Upstream project: https://github.com/juice-shop/juice-shop
- Upstream commit captured when the fork was created: `266448aba68cd8ba5915f526a128da4fa7bc3f9f`
- Application path in this lab: `juice-shop/`
- Upstream package version at that commit: `20.4.0-SNAPSHOT`

The source was relocated without changing the upstream tree in pull request #2. Lab changes after that relocation have their own commits; the eventual build provenance must identify the actual lab commit used to build the image, in addition to this upstream baseline.

## Dependency reproducibility finding

The captured upstream tree contains npm package manifests but no committed npm lockfiles. The root `package.json` postinstall also runs `npm install` in `frontend/`. Consequently, pinning the source commit alone does not fix all resolved dependencies. Before claiming repeatable dependency inputs, investigate lockfiles for both dependency trees and update the build process to use them consistently. Generating a lockfile will resolve dependencies at generation time and requires review; it does not recreate the historical dependency set.

## Repository preparation

Branch protection, Dependabot configuration and the application build are pending. GitHub Actions workflow files for this lab belong in the root `.github/workflows/`; upstream workflows retained under `juice-shop/.github/workflows/` are not active there.
