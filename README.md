<div align="center">

# asdf-lithia [![Build](https://github.com/vknabel/asdf-lithia/actions/workflows/build.yml/badge.svg)](https://github.com/vknabel/asdf-lithia/actions/workflows/build.yml) [![Lint](https://github.com/vknabel/asdf-lithia/actions/workflows/lint.yml/badge.svg)](https://github.com/vknabel/asdf-lithia/actions/workflows/lint.yml)

[lithia](https://github.com/vknabel/lithia) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add lithia
# or
asdf plugin add lithia https://github.com/vknabel/asdf-lithia.git
```

lithia:

```shell
# Show all installable versions
asdf list-all lithia

# Install specific version
asdf install lithia latest

# Set a version globally (on your ~/.tool-versions file)
asdf global lithia latest

# Now lithia commands are available
lithia --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/vknabel/asdf-lithia/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Valentin Knabel](https://github.com/vknabel/)
