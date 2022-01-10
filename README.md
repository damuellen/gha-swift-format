# GitHub Action for swift-format

The GitHub Actions for formatting Swift.

## Usage

### Example Workflow file

An example workflow to authenticate with GitHub Platform:

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
      with:
        persist-credentials: false # otherwise, the token used is the GITHUB_TOKEN, instead of your personal token
        fetch-depth: 0 # otherwise, you will failed to push refs to dest repo
    - name: Format & Commit
      uses: damuellen/gha-swift-format@main
      with:
        github_token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| name           | value   | default                     | description |
| -------------- | ------  | --------------------------- | ----------- |
| github_token   | string  |                             | Token for the repo. Can be passed in using `${{ secrets.GITHUB_TOKEN }}`. |
| author_email   | string  | 'github-actions[bot]@users.noreply.github.com' | Email used to configure user.email in `git config`. |
| author_name    | string  | 'github-actions[bot]'       | Name used to configure user.name in `git config`. |
| message        | string  | 'swift-format ${date}'      | Commit message. |
| branch         | string  | 'main'                      | Destination branch to push changes. |
| empty          | boolean | false                       | Allow empty commit. |
| directory      | string  | '.'                         | Directory to change to before formatting. |
| repository     | string  | ''                          | Repository name. Default or empty repository name represents current github repository. If you want to push to other repository, you should make a [personal access token](https://github.com/settings/tokens) and use it as the `github_token` input.  |

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE).

## No affiliation with GitHub Inc.

GitHub are registered trademarks of GitHub, Inc. GitHub name used in this project are for identification purposes only. The project is not associated in any way with GitHub Inc. and is not an official solution of GitHub Inc. It was made available in order to facilitate the use of the site GitHub.
