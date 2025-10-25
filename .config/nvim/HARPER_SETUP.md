# Harper LSP Setup for Neovim

Harper is a grammar checker that integrates with Neovim via LSP.

## Installation Complete ✓

Harper has been installed and configured in your Neovim setup.

- **Binary location**: `~/.cargo/bin/harper-ls`
- **Version**: 0.68.0
- **Configuration file**: `.config/nvim/lua/plugins/lsp-extras/harper.lua`

## Enabling Harper

Harper is controlled by an environment variable. To enable it, add this to your shell configuration:

```bash
export NVIM_ENABLE_HARPER_LSP=1
```

Then restart your shell or source your configuration file.

## Supported File Types

Harper will automatically work with the following file types:
- Markdown (`.md`)
- Rust (`.rs`)
- TypeScript/JavaScript (`.ts`, `.tsx`, `.js`)
- Python (`.py`)
- Go (`.go`)
- C/C++ (`.c`, `.cpp`)
- Ruby (`.rb`)
- Swift (`.swift`)
- C# (`.cs`)
- TOML (`.toml`)
- Lua (`.lua`)
- Git commit messages
- Java (`.java`)

## Features

Harper provides:
- Spell checking
- Grammar checking
- Style suggestions
- Punctuation corrections
- Sentence capitalization
- Long sentence detection
- Repeated word detection
- And more!

## Testing Harper

1. Enable Harper by setting the environment variable:
   ```bash
   export NVIM_ENABLE_HARPER_LSP=1
   ```

2. Restart Neovim

3. Open a markdown file with some text:
   ```bash
   nvim test.md
   ```

4. Type some text with intentional errors:
   ```markdown
   # Test Document
   
   This is a test sentence with a speling error.
   This sentence have bad grammar.
   ```

5. You should see diagnostics (underlines/highlights) for the errors

6. Use LSP commands to see suggestions:
   - `K` - Show hover documentation
   - `<leader>ca` - Show code actions (fixes)
   - `[d` and `]d` - Navigate between diagnostics

## Configuration

The Harper configuration is in `.config/nvim/lua/plugins/lsp-extras/harper.lua`.

You can customize which linters are enabled by modifying the settings in that file.

## Troubleshooting

### Harper not starting

1. Check if the environment variable is set:
   ```bash
   echo $NVIM_ENABLE_HARPER_LSP
   ```
   Should output: `1`

2. Check if harper-ls is in your PATH:
   ```bash
   which harper-ls
   ```

3. Check LSP status in Neovim:
   ```vim
   :LspInfo
   ```

4. Check if harper-ls is running:
   ```vim
   :LspLog
   ```

### Updating Harper

To update Harper to the latest version:
```bash
cargo install harper-ls --locked --force
```

## Resources

- [Harper GitHub](https://github.com/Automattic/harper)
- [Harper Documentation](https://writewithharper.com/docs/integrations/neovim)
