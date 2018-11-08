# attention

## Dependencies

### Bundler

Bundler is used to manage the version of Cocoapods used with this project. You can specify a specific version of CocoaPods in the Gemfile.

1. Install or update to the latest version of Bundler with:

```bash
gem install bundler
```

2. In the project root directory, install the dependencies specified in the Gemfile.

```bash
bundle install
```

### CocoaPods

CocoaPod dependencies are defined in the Podfile.

#### Installing a pod

To install a new pod, add an entry in the Podfile and run the install command.

```bash
bundle exec pod install --repo-update
```

#### Updating pods

You can view outdated pods.

```bash
bundle exec pod outdated
```

Updating a single pod.

```bash
bundle exec pod update SwiftLint
```
