# Typst SSG Util Package

A Typst package that provides utility functions for the Typst Static Site Generator project.

- [Main Repository](https://github.com/k0src/Typst-SSG)
- [npm Package Repository](https://github.com/k0src/Typst-SSG-Package)
- **[Typst Package Repository](https://github.com/k0src/Typst-SSG-Util-Package)**

## Usage

This package provides various utility functions for use with the [Typst SSG npm package](https://github.com/k0src/Typst-SSG-Package). Most functions in this package require some kind of post-processing with Typst SSG to work correctly. They will not throw errors when used in standalone Typst documents, but they will not function as intended (most will just show placeholders).

### Installation

To use the package, import the library in your Typst document:

```typst
#import "@preview/tssg-util:0.1.0": *
```

#### Manual Installation

Copy the `lib.typ` and `typst.toml` files into the Typst data directory on your system at `{data-dir}/typst/packages/local/tssg-util/0.1.0`.

- On Windows: `%APPDATA%`
- On macOS: `~/Library/Application Support/`
- On Linux: `$XDG_DATA_HOME` or `~/.local/share/`

Import the package in your Typst document:

```typst
#import "@local/tssg-util/0.1.0": *
```

For more information on the package API, see the [documentation](https://github.com/k0src/Typst-SSG-Util-Package/blob/master/docs/docs.pdf).

## Dependencies

- [fontawesome](https://typst.app/universe/package/fontawesome/)

## Contributing

Contributions are welcome. Please open issues and pull requests for the Typst package on this repository.

## License

[MIT](https://github.com/k0src/Typst-SSG-Util-Package/blob/master/LICENSE)
