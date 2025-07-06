# 🚀 Cloud9 IDE One-Click Installer

instalasi **Cloud9 IDE** pada Ubuntu (tested: 22.04).

---

## 🚀 Quick Start

```bash
# Download installer
curl -O https://raw.githubusercontent.com/bl0ks/c9/main/install_cloud9.sh

# Beri permission eksekusi
chmod +x install_cloud9.sh

# Jalankan installer ✨
./install_cloud9.sh
```

Setelah selesai, akses Cloud9 IDE Anda di:
http://YOUR_SERVER_IP:8080

## ⚙️ Configuration

| Variabel        | Nilai Default     | Deskripsi                  |
| --------------- | ----------------- | -------------------------- |
| `C9_PORT`       | `8080`            | Port yang digunakan Cloud9 |
| `C9_USERNAME`   | `"root"`          | Username login Cloud9      |
| `C9_PASSWORD`   | `"Password@2025"` | Password login Cloud9      |
| `WORKSPACE_DIR` | `"$HOME/project"` | Direktori workspace Cloud9 |

## 🙏 Credits

- [Cloud9 Core Documentation](https://github.com/c9/core)
