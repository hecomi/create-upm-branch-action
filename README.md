create-upm-branch-action
========================

This is a Github Action to create release branches for Unity Package Manager.

How to Use
----------

Prepare a main branch structure as shown below. I prefer this structure because it is easy to create an unitypackage as well.

```
<Repository>
  ├── README.md
  ├── Assets
  │   └── [YourPluginName]
  │         ├── package.json
  │         ├── Runtime
  │         │    ├── [YourPluginName].asmdef
  │         │    └── ...
  │         └── Samples
  │               ├── Sample 1
  │               ├── Sample 2
  │               ├── Sample 3
  │               └── ...
  ├── ...
```

Next, create the following GitHub Actions.


```yaml
name: Update-UPM-Branch

on:
  push:
    tags:
      - v*

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
        with:
          fetch-depth: 0

      - name: Tag name
        id: tag
        run: echo ::set-output name=name::${GITHUB_REF#refs/tags/v}

      - name: Create UPM Branches
        uses: hecomi/create-upm-branch-action@main
        with:
          git-tag: ${{ steps.tag.outputs.name }}
          pkg-root-dir-path: Assets/[YourPluginName]
```

,Then, when a tag like `v1.0.0` is pushed to the GitHub repository, it automatically creates an upm branch with the following structure. The version number in the *package.json* is also updated automatically.

```
<Repository>
  ├── README.md
  ├── package.json
  ├── Runtime
  │         ├── [YourPluginName].asmdef
  │         └── ...
  ├─ Samples~
  │         ├── Sample 1
  │         ├── Sample 2
  │         ├── Sample 3
  │         └── ...
  ├── ...
```

Users will be able to use your plugin in Unity with a URL like the following:

- `https://github.com/[YourGitHubID]/[YourPluginName].git#upm`


Demo
----

This is used in the following project.

- https://github.com/hecomi/uOSC


Parameters
----------

- git-tag
    - Give this as in the sample above.
- main-branch
    - Specify the main of your main branch. The default is `main`.
- upm-branch
    - The UPM branch name. The default is `upm`.
- pkg-root-dir-path
    - The root path for packaging. Most likely it will be `Assets` or `Assets/[YourPluginName]`.
- sample-dir
    - The name of the directory containing the samples. The default is `Samples`.
- root-files
    - Give a space-separated list of files, such as *README.md*, that are located in the root directory and to be included in the package. The default is `README.md LICENSE.md CHANGELOG.md`.
