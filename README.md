# OSRM Backend Binaries

This repository publishes prebuilt OSRM backend command-line binaries for Linux,
macOS, and Windows.

The releases are built from upstream
[Project-OSRM/osrm-backend](https://github.com/Project-OSRM/osrm-backend)
release tags and are primarily maintained to support the
[e-kotov/osrm.backend](https://github.com/e-kotov/osrm.backend) R package.
They can also be downloaded and used directly by other tools that need the OSRM
backend executables.

## What These Releases Contain

Each release provides standalone archives for supported platforms:

- `osrm-<version>-linux-x64-Release.tar.gz`
- `osrm-<version>-linux-arm64-Release.tar.gz`
- `osrm-<version>-darwin-x64-Release.tar.gz`
- `osrm-<version>-darwin-arm64-Release.tar.gz`
- `osrm-<version>-win32-x64-Release.tar.gz`

The archives contain OSRM backend executables such as:

- `osrm-extract`
- `osrm-contract`
- `osrm-customize`
- `osrm-partition`
- `osrm-routed`

These are backend binary releases. They do not package the upstream Node.js
bindings, npm package metadata, or `node_osrm` artifacts. This repository is not
intended to replace the official OSRM Node.js distribution; it provides the
backend command-line tools needed by the R package and similar workflows.

## Why This Repository Exists

The R package needs reliable access to OSRM backend binaries across operating
systems without requiring users to compile OSRM locally. Building OSRM from
source can be slow and platform-specific, especially on Windows. This repository
keeps those builds in one place so the R package can install the correct binary
release by OSRM version, operating system, and CPU architecture.

The binaries are useful outside R as well, but the release layout, naming, and
validation are designed around the needs of
[e-kotov/osrm.backend](https://github.com/e-kotov/osrm.backend).

## Release Policy

Releases in this repository are immutable GitHub Releases. Once a version is
published, its assets are not replaced in place. If a build or packaging issue
needs to be corrected, the fix should be made in a new release or with an
explicitly documented new asset/versioning strategy.

Release notes link back to the corresponding upstream OSRM release so users can
inspect the original OSRM changelog and source tag.

New stable upstream OSRM releases are checked automatically once per day. When a
new upstream stable tag appears, this repository dispatches the binary build
workflow for that tag. Older historical tags are not backfilled automatically.

## Checksums

Every release includes SHA-256 verification data in two forms:

- GitHub release asset digests, available through the GitHub Releases API.
- A `checksums.txt` asset for compatibility with clients and scripts that expect
  a checksum file.

The R package prefers the GitHub Releases API asset digests and keeps
`checksums.txt` as a fallback.

## Relationship To Upstream OSRM

These binaries are built from upstream OSRM source tags, but this repository is
not the official OSRM release channel. For OSRM source code, issue tracking,
project documentation, and upstream changelogs, use
[Project-OSRM/osrm-backend](https://github.com/Project-OSRM/osrm-backend).
