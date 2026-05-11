# QRESID_PUBLIC_RELEASE_ASSET_POLICY.md

## 1. Purpose

This master defines how `qresid` release files are separated across:

- the public package repository `psotob91/qresid`;
- the private maintenance workspace `qresid-research-program`;
- SSC submission materials;
- GitHub Release assets.

It is an internal maintenance policy. It is not part of the Stata package.

## 2. Public `qresid` repository

The public repository may contain:

- `qresid.ado`, `qresid.sthlp`, `qresid.pkg`, and `stata.toc`;
- `README.md`, changelog, license, citation, and public contribution files;
- public Markdown documentation, tutorial assets, examples, tests, and CI;
- scripts that build or test release artifacts.

The public repository must not track:

- `release/` or `releases/`;
- ZIP files, checksums, staging folders, or generated release notes;
- temporary logs, caches, local smoke outputs, or working directories;
- internal audits, prompts, conversations, or planning notes.

## 3. SSC package state

SSC is the official user-facing distribution channel once a version is accepted.

For an accepted version, the installed artifacts are frozen:

- do not change `qresid.ado`;
- do not change `qresid.sthlp`;
- do not silently modify accepted package metadata.

If an installed artifact must change, create a new version or submit a formal
SSC revision. GitHub README and documentation may describe the current SSC
availability without changing the accepted help file.

## 4. SSC ZIP handling

The SSC ZIP is built locally with:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File qresid\scripts\build_ssc_submission.ps1
```

The ZIP may be attached to a GitHub Release as a reproducible snapshot, but it
must not be committed to Git. The staging directory and ZIP are ignored
regenerables.

The SSC ZIP contains only files approved by the build script, typically:

- `qresid.ado`;
- `qresid.sthlp`;
- `qresid_examples.do`;
- `qresid_ssc_cover_note.txt`.

It must not contain GitHub docs, tests, logs, images, benchmarks, package
manifests, `qresid.pkg`, or `stata.toc` unless SSC explicitly requests them.

## 5. GitHub Release assets

For each public version:

1. confirm `main` and the release tag point to the intended commit;
2. build the SSC ZIP locally;
3. inspect the ZIP contents;
4. create or edit the GitHub Release;
5. attach the ZIP as a release asset if useful;
6. verify the release by API or browser.

The GitHub Release body should state SSC status accurately:

- before acceptance: "submitted to SSC; pending review";
- after acceptance: "Accepted and distributed through SSC."

Do not claim SSC acceptance before verifying availability from the SSC/Boston
College archive.

## 6. Private maintenance workspace

The private `qresid-research-program` repository may contain masters, matrices,
audits, literature notes, and maintenance context. It should not track obsolete
execution logs, transient smoke-test outputs, caches, ZIPs, or staging folders.

The `qresid/` directory is a separate Git repository. The root workspace tracks
only its gitlink. Do not duplicate the public repository contents elsewhere in
the root workspace.
