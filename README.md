<div align="center">

# asdf-kakoune [![Build](https://github.com/gzh2003/asdf-kakoune/actions/workflows/build.yml/badge.svg)](https://github.com/gzh2003/asdf-kakoune/actions/workflows/build.yml) [![Lint](https://github.com/gzh2003/asdf-kakoune/actions/workflows/lint.yml/badge.svg)](https://github.com/gzh2003/asdf-kakoune/actions/workflows/lint.yml)

[kakoune](http://kakoune.org/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, `make` and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- C++20 compliant compiler (GCC >= 10.3 or clang >= 11)
- C++ standard library (libstdc++ >= 10 or libc++)

# Install

Plugin:

```shell
asdf plugin add kakoune
# or
asdf plugin add kakoune https://github.com/gzh2003/asdf-kakoune.git
```

kakoune:

```shell
# Show all installable versions
asdf list-all kakoune

# Install specific version
asdf install kakoune latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kakoune latest

# Now kakoune commands are available
kak -version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/gzh2003/asdf-kakoune/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [gzh2003](https://github.com/gzh2003/)
