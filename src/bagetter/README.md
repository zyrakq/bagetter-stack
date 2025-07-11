# 🍰 BaGetter Deployment

## 🚀 Quick Start

Use the universal deployment script with different configurations:

```bash
# 🔧 Development with port forwarding (default)
./deploy.sh

# 🌐 Production with Let's Encrypt certificates
./deploy.sh --production --letsencrypt

# 🏢 Production with Step CA certificates
./deploy.sh --production --step-ca

# 🔒 Development with Let's Encrypt
./deploy.sh --letsencrypt

# 🛡️ Development with Step CA
./deploy.sh --step-ca

# ❓ Show help and all available commands
./deploy.sh --help
```

## 📦 Components

### 🔐 **Access Control** (`docker-compose.access.yml`)

- **Web Interface**: Adds login/password authentication for web access
- **API Security**: Requires username, password, and API key for package management operations
- **Production Ready**: Essential for production deployments with package publishing

### 🌍 **Let's Encrypt** (`docker-compose.letsencrypt.yml`)

- **Auto SSL**: Automatic SSL certificate provisioning and renewal
- **Production SSL**: Uses Let's Encrypt for trusted certificates
- **External Network**: Connects to `letsencrypt-network` for certificate management

### 🏠 **Step CA** (`docker-compose.step-ca.yml`)

- **Internal SSL**: Self-signed certificate authority for private networks
- **Development SSL**: Perfect for internal/development environments
- **Private Network**: Connects to `step-ca-network` for certificate management

### 🔌 **Port Forwarding** (`docker-compose.forwarding.yml`)

- **Direct Access**: Exposes BaGetter on port 5555
- **Development Only**: Simple setup without SSL or authentication
- **Local Testing**: Ideal for local development and testing

## ⚙️ Configuration

Copy `.env.example` to `.env` and configure your settings before deployment.
