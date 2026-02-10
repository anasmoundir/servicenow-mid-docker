# Simple ServiceNow MID Server using Docker (PDI Testing)

This repository shows how to run a **ServiceNow MID Server locally using Docker**
to test integrations from a **Personal Developer Instance (PDI)**.

This setup is intended for:
- REST integrations
- IntegrationHub testing
- Learning MID Server behavior
- Error handling (MID down, timeout, retry)

---

## Why use Docker for a MID Server?

- No need to install Linux manually
- MID Server survives PC reboots
- Easy to start / stop
- Perfect for ServiceNow PDIs

---

## Prerequisites

- Docker Desktop
- A ServiceNow PDI (Personal Developer Instance)
- A ServiceNow user with `mid_server` role

---

## Project Structure

```
servicenow-mid-docker/
├── docker/
│   ├── docker-compose.yml    # Docker Compose configuration
│   ├── Dockerfile             # MID Server container definition
│   └── .env                   # Environment variables (create this)
├── mid/
│   └── config.xml.template    # MID Server configuration template
├── scripts/
│   ├── entrypoint.sh          # Container startup script
│   └── healthcheck.sh         # Health check script
└── README.md
```

---

## Platform Compatibility

This setup supports **both Intel (x86-64) and Apple Silicon (ARM64) Macs**. The Docker configuration automatically uses platform emulation when needed.

---

## Setup Instructions

### 1. Create a MID Server user in ServiceNow

1. Log into your ServiceNow PDI
2. Navigate to **User Administration > Users**
3. Create a new user with the `mid_server` role
4. Note the username and password

### 2. Configure Environment Variables

Create a `.env` file in the `docker/` directory:

```bash
cd docker
cp .env.example .env
```

Edit `.env` with your ServiceNow credentials:

```env
MID_INSTANCE_URL=https://your-instance.service-now.com
MID_USERNAME=your_mid_user
MID_PASSWORD=your_password
MID_NAME=docker_mid_server
```

### 3. Start the MID Server

From the `docker/` directory:

```bash
cd docker
docker-compose up -d --build
```

The build process may take a few minutes on first run as it downloads the MID installer (~300MB).

### 4. Verify MID Server Status

Check the container logs:

```bash
docker logs -f sn-mid-server
```

Look for messages indicating the MID Server is running and connecting to your instance.

In ServiceNow:
1. Navigate to **MID Server > Servers**
2. Look for your MID Server name (e.g., `docker_mid_server`)
3. Status should show **Up** (may take 2-3 minutes)

---

## Managing the MID Server

### View Logs

```bash
cd docker
docker logs -f sn-mid-server
```

### Stop the MID Server

```bash
cd docker
docker-compose down
```

### Restart the MID Server

```bash
cd docker
docker-compose restart
```

### Rebuild from Scratch

```bash
cd docker
docker-compose down -v
docker-compose up -d --build
```

---

## Troubleshooting

### Apple Silicon (M1/M2/M3) Macs

The setup automatically handles platform compatibility using Docker's AMD64 emulation. The container runs in `linux/amd64` mode to match the MID Server installer architecture.

### Container Keeps Restarting

1. Check logs: `docker logs sn-mid-server`
2. Verify `.env` file exists in `docker/` directory
3. Ensure credentials are correct
4. Check if ServiceNow instance URL is accessible

### MID Server Shows "Down" in ServiceNow

1. Verify network connectivity from container to ServiceNow instance
2. Check username/password in `.env` file
3. Ensure the user has `mid_server` role
4. Review MID Server logs for connection errors

### Configuration Changes

After modifying `.env`:

```bash
cd docker
docker-compose down
docker-compose up -d
```

---

## What This Setup Includes

- **Platform Support**: Works on Intel and Apple Silicon Macs
- **Auto-configuration**: Environment-based configuration via `.env`
- **Health Checks**: Automatic container health monitoring
- **Persistent Data**: MID Server data persists across restarts
- **Easy Management**: Simple docker-compose commands

---

## Use Cases

- REST integrations testing with PDI
- IntegrationHub development and debugging
- Learning MID Server behavior and configuration
- Testing error handling (MID down, timeouts, retries)
- Local development without cloud MID servers

---

## Security Notes

⚠️ **Important**: The `.env` file contains sensitive credentials and is excluded from git via `.gitignore`. Never commit this file to version control.

---

## Architecture

The MID Server runs inside a Docker container on your local machine and connects securely to your ServiceNow PDI over HTTPS.

```
┌─────────────────┐         HTTPS            ┌──────────────────┐
│  Docker         │ ◄──────────────────────► │  ServiceNow PDI  │
│  MID Server     │    Secure Connection     │                  │
│  Container      │                          │                  │
└─────────────────┘                          └──────────────────┘
```

---

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

---

## License

This project is provided as-is for educational and development purposes.



