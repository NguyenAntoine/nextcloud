# Nextcloud Docker Compose Setup

Self-hosted file storage and collaboration platform using Docker Compose.

**Documentation:** [Nextcloud Docker Image](https://github.com/nextcloud/docker)

---

## Quick Start

### 1. Create Environment File

Copy the example configuration:

```bash
cp .env.dist .env
```

Edit `.env` with your settings:

```bash
VIRTUAL_HOST=your-domain.com
LETSENCRYPT_HOST=your-domain.com
LETSENCRYPT_EMAIL=your-email@example.com
MYSQL_ROOT_PASSWORD=<strong-password>
MYSQL_PASSWORD=<strong-password>
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=<strong-password>
```

**Generate strong passwords:**
```bash
openssl rand -base64 32
```

### 2. Start Services

```bash
# Using modern Docker Compose (v2+)
docker compose up -d

# Wait for services to start
sleep 30

# Check status
docker compose ps

# View logs
docker compose logs -f app
```

### 3. Verify Installation

- Open `https://your-domain.com`
- Login with credentials from `.env`
- Verify files are present

---

## Updating Docker Images

To update Nextcloud and database images to latest patch versions:

```bash
./updateDockerImages.sh
```

**Note:** This keeps the major versions specified in `docker-compose.yml`. For major version upgrades, edit the image versions first.

---

## Configuration

### File Upload Limits

Increase maximum upload file size to 2GB:

```yaml
# docker-compose.yml (already configured)
environment:
  - PHP_UPLOAD_LIMIT=2048M
```

Update nginx proxy configuration:

```bash
# In nginx-proxy/nginx.conf
http {
    ...
    client_max_body_size 2000M;
}
```

### Database Performance (Optional)

Uncomment in `docker-compose.yml` for better performance:

```bash
command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
```

### Database Administration

**Option 1: SSH Tunnel (Recommended)**

```bash
ssh -L 8888:localhost:3306 user@your-server
# Connect to: localhost:8888 with your MySQL client
```

**Option 2: PhpMyAdmin (Uncomment in docker-compose.yml)**

```bash
# Uncomment the phpmyadmin service
docker compose up -d
# Access at http://localhost:8988
```

---

## Backup & Restore

### Backup Nextcloud Data

```bash
# Backup files
tar -czf nextcloud_backup.tar.gz ./data/nextcloud/

# Backup database
docker exec nextcloud_db mysql -u nextcloud -p nextcloud > nextcloud.sql
```

### Restore from Backup

```bash
# Stop services
docker compose down

# Restore files
tar -xzf nextcloud_backup.tar.gz

# Start and restore database
docker compose up -d
docker exec nextcloud_db mysql -u nextcloud -p nextcloud < nextcloud.sql
docker exec nextcloud_app chown -R www-data:www-data /var/www/html/data

# Restart
docker compose restart
```

---

## Troubleshooting

### Container Logs

```bash
# View Nextcloud app logs
docker compose logs -f app

# View database logs
docker compose logs -f db

# View all logs
docker compose logs -f
```

### Container Health

```bash
# Check container status
docker compose ps

# Run health check
docker compose ps --status
```

### Reset Services

```bash
# Stop all containers
docker compose down

# Remove data (WARNING: Destructive!)
rm -rf ./data/

# Restart
docker compose up -d
```

---

## Networking

Services are connected to:
- **default:** Internal network for container-to-container communication
- **reverse-proxy:** External network for nginx reverse proxy (must exist)

Create reverse-proxy network if it doesn't exist:

```bash
docker network create reverse-proxy
```

---

## Security Notes

- ✅ Use strong passwords (32+ characters)
- ✅ Keep backups in secure location
- ✅ Regular database backups recommended
- ✅ Use HTTPS (configured via Let's Encrypt)
- ✅ Don't expose PhpMyAdmin in production (use SSH tunnel instead)
- ✅ Keep Docker images updated: `docker compose pull && docker compose up -d`

---

## Docker Compose Version

Requires Docker Compose v2+ (use `docker compose` instead of `docker-compose`)

```bash
# Check version
docker compose version
```

---

**Last Updated:** 2026-02-02
