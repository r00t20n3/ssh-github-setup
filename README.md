# Frank I - GitHub SSH Setup

A clean, simple command-line tool for setting up SSH authentication with GitHub. No more password prompts - just secure SSH connections!

## What This Tool Does

- **Generates SSH keys** for secure GitHub authentication
- **Adds keys to your SSH agent** automatically  
- **Copies public key to clipboard** for easy GitHub setup
- **Tests your connection** to verify everything works

## Features

✅ **Automatic Key Generation** - Creates Ed25519 keys (falls back to RSA if needed)  
✅ **Cross-Platform Clipboard** - Works on macOS, Linux, and Windows  
✅ **Connection Testing** - Verifies your setup actually works  
✅ **Clean Interface** - Simple, distraction-free CLI  
✅ **Step-by-Step Guidance** - Clear instructions for GitHub setup  

## Quick Start

1. **Download and run:**
   ```bash
   curl -O https://raw.githubusercontent.com/frankrevops/LAZY-GIT-SSH-SETUP/master/lazy-git.sh
   chmod +x lazy-git.sh
   ./lazy-git.sh
   ```

2. **Choose option 1** for full setup
3. **Enter your email** when prompted
4. **Follow the GitHub instructions** displayed
5. **Done!** Your SSH is ready to use

## Menu Options

| Option | Description |
|--------|-------------|
| **1** | Full Setup (Generate + Add + Test) |
| **2** | Generate Key Only |
| **3** | Add to SSH Agent |
| **4** | Test Connection |
| **5** | Show Public Key |
| **6** | Exit |

## Requirements

- **Bash shell** (macOS, Linux, Windows with Git Bash)
- **SSH tools** (usually pre-installed)
- **Internet connection** for GitHub testing

## How It Works

### Step 1: Generate SSH Key
- Creates Ed25519 key (recommended) or RSA fallback
- Uses your email as the key comment
- Saves to standard SSH directory (`~/.ssh/`)

### Step 2: Add to SSH Agent
- Starts SSH agent if not running
- Adds your new key to the agent
- Enables password-free authentication

### Step 3: GitHub Setup
- Copies public key to clipboard automatically
- Provides clear GitHub setup instructions
- Walks you through adding the key to your account

### Step 4: Test Connection
- Verifies SSH connection to GitHub
- Confirms everything is working properly
- Provides troubleshooting tips if needed

## Troubleshooting

**Connection test fails?**
- Verify you added the key to GitHub correctly
- Check your internet connection
- Try: `ssh -vT git@github.com` for detailed output

**Key generation fails?**
- Ensure SSH tools are installed
- Check file permissions on `~/.ssh/` directory
- Try running with sudo if permission issues persist

**Clipboard not working?**
- The tool will display your key if clipboard fails
- Manually copy the displayed key to GitHub

## Security Notes

- Keys are generated with no passphrase for convenience
- Ed25519 keys are preferred for better security
- Private keys remain on your local machine only
- Public keys are safe to share (that's their purpose!)

## Platform Support

| Platform | Status | Clipboard Tool |
|----------|--------|----------------|
| **macOS** | ✅ Full Support | `pbcopy` |
| **Linux** | ✅ Full Support | `xclip` |
| **Windows** | ✅ Full Support | `clip` |

## About

Created by **Frank I.**  
Connect: [linkedin.com/in/frankrevops](https://linkedin.com/in/frankrevops)

---

## License

MIT License - feel free to use, modify, and distribute!

## Contributing

Found a bug or want to improve something? Pull requests welcome!

---

*No more typing passwords for Git operations - enjoy your secure SSH setup! 🚀*
