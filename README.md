create-upm-branch-action
========================

This is a Github Action to create release branches for Unity Package Manager.

How to Use
----------

First, prepare a main branch structure as shown below. I recommend this structure because it also makes it easy to create a Unity package.

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

Then, create the following GitHub Actions.


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

This Action requires Write permissions to add branches to your repository. Please configure the settings as per the instructions on the following page: 

- [Setting the permissions of the GITHUB_TOKEN for your repository](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#setting-the-permissions-of-the-github_token-for-your-repository).

When a tag like `v1.0.0` is pushed to the GitHub repository, it will automatically create a branch named `upm` with the following structure. The version number in the *package.json* is also updated automatically.

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

Users can then use your plugin in Unity with a URL like:

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
- samples-dir
    - The name of the directory containing the samples. The default is `Samples`.
- root-files
    - Give a space-separated list of files, such as *README.md*, that are located in the root directory and to be included in the package. The default is `README.md LICENSE.md CHANGELOG.md`.

Publishing to npm
-----------------

To publish your plugin to npm, you aditionally need to:

1. Create an npm account.
2. Generate an Access Token for each repository. This token will be used as a secret named `NPM_TOKEN`.
  - Refer to [Publishing Node.js packages on GitHub](https://docs.github.com/ja/actions/publishing-packages/publishing-nodejs-packages) for more details.
3. Add the following lines to your GitHub Actions:

```yaml
name: Update-UPM-Branch
...
jobs:
  update:
    ...
    steps:
      ...

      - name: Tag name
        ...

      - name: Create UPM Branches
        ...

      - name: Setup node
        uses: actions/setup-node@v2
        with:
          registry-url: 'https://registry.npmjs.org'

      - name: NPM publish
        run: npm publish --access public
        env:
          NODE_AUTH_TOKEN: ${{secrets.NPM_TOKEN}}
```
