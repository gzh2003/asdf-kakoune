# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

asdf plugin test kakoune https://github.com/gzh2003/asdf-kakoune.git "kak -version"
```

Tests are automatically run in GitHub Actions on push and PR.
