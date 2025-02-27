# CircleCI orb for AppZung CodePush

[![CircleCI Build Status](https://circleci.com/gh/AppZung/circleci-deploy-to-appzung-codepush-orb.svg?style=shield "CircleCI Build Status")](https://circleci.com/gh/AppZung/circleci-deploy-to-appzung-codepush-orb) [![CircleCI Orb Version](https://badges.circleci.com/orbs/appzung/deploy-to-appzung-codepush.svg)](https://circleci.com/developer/orbs/orb/appzung/deploy-to-appzung-codepush) [![GitHub License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/AppZung/circleci-deploy-to-appzung-codepush-orb/master/LICENSE) [![CircleCI Community](https://img.shields.io/badge/community-CircleCI%20Discuss-343434.svg)](https://discuss.circleci.com/c/ecosystem/orbs)

This orb installs the AppZung CLI and uses it to deploy your React Native update to AppZung CodePush.
This way, your new features or bug fixes will become available to your users much earlier than if you were going through the app store reviews, and development iterations are much faster.
Sign up first at https://appzung.com

## Usage

Example usage in your CircleCI config:

```yaml
version: 2.1
orbs:
  appzung-codepush: appzung/deploy-to-appzung-codepush@1.0.0

workflows:
  deploy-react-native-update:
    jobs:
      - appzung-codepush/deploy-react-native:
          api_key: ${APPZUNG_API_KEY}
          release_channel: "Production/c95d7950-228c-4f47-8abb-4e275050ca8e"
          mandatory: "no" # Whether the update is mandatory
          disabled: "no" # Whether the update should be disabled initially
          rollout: "100" # Percentage of users to rollout to
          description_from_git: "yes" # Use current git commit as description
          package_manager: "yarn" # Package manager to use (npm or yarn)
          node-version: "lts" # Node.js version to use
          install_dependencies: true # Whether to install dependencies
```

## Parameters

### Required

- `api_key`: AppZung API key for authentication. An API key that has access to this project.
- `release_channel`: The release channel ID to deploy to (eg. 'myReleaseChannelDescription/c95d7950-228c-4f47-8abb-4e275050ca8e')

### Optional

- `mandatory`: Whether this release should be considered mandatory ("yes" or "no", default: "no")
- `disabled`: Whether this release should be disabled initially ("yes" or "no", default: "no")
- `rollout`: Percentage of users this release should be available to (eg. "95" for 95%)
- `target_binary_version`: Semver version that specifies the binary app version this release is compatible with
- `private_key_path`: Path to the private key file for code signing
- `description_from_git`: Use the current git commit message as release description ("yes" or "no", default: "no")
- `extra_flags`: Additional command line flags to pass to the deploy command (eg. "--disable-duplicate-release-error --use-hermes")
- `package_manager`: Package manager to use for installing dependencies ("npm" or "yarn", default: "npm")
- `node-version`: Node.js version to use for deployment (default: "lts")
- `install_dependencies`: Whether to install dependencies before deploying (true or false, default: true)


---

### How to Contribute

We welcome [issues](https://github.com/AppZung/circleci-deploy-to-appzung-codepush-orb/issues) to and [pull requests](https://github.com/AppZung/circleci-deploy-to-appzung-codepush-orb/pulls) against this repository!

### How to Publish An Update
1. Merge pull requests with desired changes to the main branch.
    - For the best experience, squash-and-merge and use [Conventional Commit Messages](https://conventionalcommits.org/).
2. Find the current version of the orb.
    - You can run `circleci orb info appzung/codepush-deploy | grep "Latest"` to see the current version.
3. Create a [new Release](https://github.com/AppZung/circleci-deploy-to-appzung-codepush-orb/releases/new) on GitHub.
    - Click "Choose a tag" and _create_ a new [semantically versioned](http://semver.org/) tag. (ex: v1.0.0)
      - We will have an opportunity to change this before we publish if needed after the next step.
4.  Click _"+ Auto-generate release notes"_.
    - This will create a summary of all of the merged pull requests since the previous release.
    - If you have used _[Conventional Commit Messages](https://conventionalcommits.org/)_ it will be easy to determine what types of changes were made, allowing you to ensure the correct version tag is being published.
5. Now ensure the version tag selected is semantically accurate based on the changes included.
6. Click _"Publish Release"_.
    - This will push a new tag and trigger your publishing pipeline on CircleCI.

### Development Orbs

Prerequisites:

- An initial sevmer deployment must be performed in order for Development orbs to be published and seen in the [Orb Registry](https://circleci.com/developer/orbs).

A [Development orb](https://circleci.com/docs/orb-concepts/#development-orbs) can be created to help with rapid development or testing. To create a Development orb, change the `orb-tools/publish` job in `test-deploy.yml` to be the following:

```yaml
- orb-tools/publish:
    orb_name: appzung/codepush-deploy
    vcs_type: << pipeline.project.type >>
    pub_type: dev
    # Ensure this job requires all test jobs and the pack job.
    requires:
      - orb-tools/pack
      - command-test
    context: orb-publishing
    filters: *filters
```

The job output will contain a link to the Development orb Registry page. The parameters `enable_pr_comment` and `github_token` can be set to add the relevant publishing information onto a pull request. Please refer to the [orb-tools/publish](https://circleci.com/developer/orbs/orb/circleci/orb-tools#jobs-publish) documentation for more information and options.
