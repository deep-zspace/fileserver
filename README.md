# File Server

A Docker-based file server with web interface and SMB network sharing.

## Features

- **File Browser**: Web-based file management with upload/download
- **SMB/Samba**: Network file sharing for local access
- **Ngrok Tunnel**: Secure internet access to your files

## Requirements

- Docker
- Docker Compose
- Python 3 (for additional tools)

## Installation

0. **Clone this Repo**:
```bash
git clone https://github.com/deep-zspace/fileserver.git
cd fileserver
```

1. **Run setup script**:
```bash
sudo chmod 777 ./setup.sh
./setup.sh
```

This will prompt you for:
- Data directory path
- Ngrok auth token
- Ngrok domain (optional)
- SMB username and password

2. **Start services**:
```bash
docker compose up -d
```

3. **Create File Browser user**:
```bash
docker compose stop filebrowser
docker compose run --rm filebrowser users add <username> <password> --perm.admin
docker compose start filebrowser
```

Replace `<username>` and `<password>` with your credentials.

4. **To add systemd service**:
```bash
sudo chmod 777 ./install-systemd.sh
./install-systemd.sh
```

## Usage

### Access File Browser
- **Local**: http://localhost:8081
- **Internet**: https://your-ngrok-domain.ngrok-free.app
- **Login**: Use credentials created in step 4

### Access SMB Share
- **Address**: `smb://your-server-ip/movies`
- **Login**: Use SMB credentials from setup

### Ngrok Dashboard
- **URL**: http://localhost:4040

## File Structure

```
fileserver/
├── config/
│   ├── filebrowser.db          # File Browser database
│   └── filebrowser.json        # File Browser config
├── docker-compose.yml          # Docker services configuration
├── setup.sh                    # Initial setup script
├── install-systemd.sh          # Systemd service installer
├── requirements.txt            # Python dependencies
├── .env                        # Environment variables (created by setup.sh)
└── README.md                   # This file
```



## Commands

### Start services
```bash
docker compose up -d
```

### Stop services
```bash
docker compose down
```

### View logs
```bash
docker compose logs -f
```

### Restart a service
```bash
docker compose restart <service-name>
```

### Systemd Service
```bash
  Status:   sudo systemctl status fileserver
  Start:    sudo systemctl start fileserver
  Stop:     sudo systemctl stop fileserver
  Restart:  sudo systemctl restart fileserver
  Logs:     docker compose logs -f
```


### Reset File Browser password
```bash
docker compose stop filebrowser
docker compose run --rm filebrowser users update <username> --password <new-password>
docker compose start filebrowser
```

### Check service status
```bash
docker compose ps
```
