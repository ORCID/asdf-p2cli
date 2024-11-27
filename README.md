<div align="center">

# asdf-p2cli [![Build](https://github.com/ORCID/asdf-p2cli/actions/workflows/build.yml/badge.svg)](https://github.com/ORCID/asdf-p2cli/actions/workflows/build.yml) [![Lint](https://github.com/ORCID/asdf-p2cli/actions/workflows/lint.yml/badge.svg)](https://github.com/ORCID/asdf-p2cli/actions/workflows/lint.yml)


[p2cli](https://github.com/wrouesnel/p2cli) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add p2cli https://github.com/ORCID/asdf-p2cli.git
```

p2cli:

```shell
# Show all installable versions
asdf list-all p2cli

# Install specific version
asdf install p2cli latest

# Set a version globally (on your ~/.tool-versions file)
asdf global p2cli latest

# Now p2cli commands are available
p2cli --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/ORCID/asdf-p2cli/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [ORCID] (https://github.com/ORCID/)
