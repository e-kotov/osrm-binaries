# OSRM Backend Binaries

This repository publishes prebuilt OSRM backend command-line binaries for Linux,
macOS, and Windows.

The releases are built from upstream
[Project-OSRM/osrm-backend](https://github.com/Project-OSRM/osrm-backend)
release tags and are primarily maintained to support the
[e-kotov/osrm.backend](https://github.com/e-kotov/osrm.backend) R package.
They can also be downloaded and used directly by other tools that need the OSRM
backend executables.

Compared with the official upstream release artifacts, these archives are built
with the R package use case in mind: backend executables, predictable asset
names, checksum verification, and bundled runtime libraries where practical.

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

## Portable Runtime Packaging

The release workflow aims to make the archives portable enough to run on normal
user machines without asking users to install the full OSRM build toolchain.

For Linux, binaries are currently built on GitHub-hosted Ubuntu 24.04 runners
for `x64` and `arm64`. During packaging, the workflow bundles the dynamic Boost
and TBB libraries used by the OSRM executables and rewrites the executable RPATH
to load those libraries from the archive directory. The release test job audits
the packaged executables with `ldd` and fails if required Boost or TBB runtime
libraries are still resolved from outside the package.

This matters because upstream OSRM release artifacts may move to newer build
images over time. When binaries are built on a newer Linux distribution without
bundling the right runtime libraries, they can stop working on older Linux
systems. Our goal is to reduce that problem for R package users by packaging the
runtime libraries that are most likely to cause this kind of breakage.

The Linux archives are not claimed to be universal static binaries. They still
depend on core system libraries such as glibc and the platform loader provided
by the host OS. Within that constraint, the workflow is designed and tested to
be as self-contained as practical.

The effective Linux compatibility floor is the highest `GLIBC_*` symbol required
by the packaged executables and bundled shared libraries. For example, the
published `v26.7.3` Linux `x64` and `arm64` archives currently require symbols
up to `GLIBC_2.38`. Systems with an older glibc than that are not expected to run
those archives. Future releases may have a different floor depending on the
build image, compiler, and bundled library versions, so compatibility should be
checked per release when supporting older Linux distributions matters.

On macOS and Windows, the workflow follows the same portability principle:
Homebrew/vcpkg runtime libraries needed by the shipped executables are copied
into the archive, and the package test jobs check that the executables can start
from the extracted package.

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

New stable upstream OSRM releases are checked automatically once per day at
00:17 UTC. When a new upstream stable tag appears after the current baseline,
this repository dispatches the binary build workflow for that tag. That means
new releases here are not published at exactly the same moment as upstream OSRM;
they are normally picked up by the next daily check and then published after the
platform build and package tests complete. Older historical tags are not
backfilled automatically.

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
