# 🍰 BaGetter Service

A modular Docker Compose configuration system for BaGetter NuGet server with support for multiple environments and extensions.

## 🏗️ Project Structure

```sh
src/bagetter/
├── components/                              # Source compose components
│   ├── base/                               # Base components
│   │   ├── docker-compose.yml              # Main BaGetter service
│   │   ├── .env.example                    # Base environment variables
│   │   └── Dockerfile                      # BaGetter Dockerfile
│   ├── environments/                       # Environment components
│   │   ├── forwarding/
│   │   │   └── docker-compose.yml          # Development with port forwarding
│   │   ├── letsencrypt/
│   │   │   ├── docker-compose.yml          # Let's Encrypt SSL
│   │   │   └── .env.example                # Let's Encrypt variables
│   │   └── step-ca/
│   │       ├── docker-compose.yml          # Step CA SSL
│   │       └── .env.example                # Step CA variables
│   └── extensions/                         # Extension components
│       └── guard/
│           ├── docker-compose.yml          # Authentication and API keys
│           └── .env.example                # Authentication variables
├── build/                        # Generated configurations (auto-generated)
│   ├── forwarding/
│   │   ├── base/                 # Development + base configuration
│   │   └── guard/                # Development + authentication
│   ├── letsencrypt/
│   │   ├── base/                 # Let's Encrypt + base configuration
│   │   └── guard/                # Let's Encrypt + authentication
│   └── step-ca/
│       ├── base/                 # Step CA + base configuration
│       └── guard/                # Step CA + authentication
├── build.sh                      # Build script
└── README.md                     # This file
```

## 🚀 Quick Start

### 1. Build Configurations

Run the build script to generate all possible combinations:

```bash
./build.sh
```

This will create all combinations in the `build/` directory.

### 2. Choose Your Configuration

Navigate to the desired configuration directory:

```bash
# For development with port forwarding
cd build/forwarding/base/

# For production with Let's Encrypt SSL
cd build/letsencrypt/base/

# For production with Step CA SSL
cd build/step-ca/base/

# For development with authentication
cd build/forwarding/guard/
```

### 3. Configure Environment

Copy and edit the environment file:

```bash
cp .env.example .env
# Edit .env with your values
```

### 4. Deploy

Start the services:

```bash
docker-compose up -d
```

Access: `http://localhost:5555` (for forwarding mode)

## 🔧 Available Configurations

### Environments

- **forwarding**: Development environment with port forwarding (5555)
- **letsencrypt**: Production with Let's Encrypt SSL certificates
- **step-ca**: Production with Step CA SSL certificates

### Extensions

- **guard**: Authentication with username/password and API keys

### Generated Combinations

Each environment can be combined with any extension:

- `forwarding/base` - Development with port forwarding
- `forwarding/guard` - Development with authentication
- `letsencrypt/base` - Production with Let's Encrypt SSL
- `letsencrypt/guard` - Production with Let's Encrypt + authentication
- `step-ca/base` - Production with Step CA SSL
- `step-ca/guard` - Production with Step CA + authentication

## 🔧 Environment Variables

### Base Configuration

- `STORAGE__TYPE`: Storage type (default: FileSystem)
- `STORAGE__PATH`: Storage path (default: /data)
- `DATABASE__TYPE`: Database type (default: Sqlite)
- `DATABASE__CONNECTIONSTRING`: Database connection string
- `SEARCH__TYPE`: Search type (default: Database)
- `ALLOW_PACKAGE_OWERWRITERS`: Allow package overwrites (default: true)

### Let's Encrypt Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 8080)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Step CA Configuration

- `VIRTUAL_PORT`: Port for nginx-proxy (default: 8080)
- `VIRTUAL_HOST`: Domain for nginx-proxy
- `LETSENCRYPT_HOST`: Domain for SSL certificate
- `LETSENCRYPT_EMAIL`: Email for certificate registration

### Guard Configuration (Authentication)

- `API_KEY`: API key for package access
- `BAGETTER_USERNAME`: Username for web interface
- `BAGETTER_PASSWORD`: Password for web interface

## 📦 Using NuGet Packages

### Publishing Packages

```bash
# Without authentication (base configurations)
dotnet nuget push package.nupkg --source http://localhost:5555/v3/index.json

# With authentication (guard configurations)
dotnet nuget push package.nupkg --source http://localhost:5555/v3/index.json --api-key YOUR_API_KEY
```

### Adding Package Source

```bash
# Add BaGetter as package source
dotnet nuget add source http://localhost:5555/v3/index.json --name BaGetter
```

## 🛠️ Development

### Adding New Environments

1. Create directory in `components/environments/` with `docker-compose.yml` and optional `.env.example` file
2. Run `./build.sh` to generate new combinations

### File Naming Convention

All component files follow the standard Docker Compose naming convention (`docker-compose.yml`) for:

- **VS Code compatibility**: Full support for Docker Compose language features and IntelliSense
- **IDE integration**: Proper syntax highlighting and validation in all major editors
- **Tool compatibility**: Works with Docker Compose plugins and extensions
- **Standard compliance**: Follows official Docker Compose file naming patterns

### Modifying Existing Components

1. Edit the component files in `components/`
2. Run `./build.sh` to regenerate configurations
3. The `build/` directory will be completely recreated

## 🌐 Networks

- **Development**: `bagetter-network` (internal)
- **Let's Encrypt**: `letsencrypt-network` (external)
- **Step CA**: `step-ca-network` (external)

## 🔒 Security

⚠️ **Production Checklist:**

- Change default API key
- Use strong passwords for authentication
- Configure firewall rules
- Regular security updates

## 🆘 Troubleshooting

**Build Issues:**

- Ensure `yq` is installed: <https://github.com/mikefarah/yq#install>
- Check component file syntax
- Verify all required files exist

**Package Publishing Issues:**

- Check API key correctness
- Ensure service is running and accessible
- Review container logs: `docker logs bagetter`

**SSL Issues:**

- **Let's Encrypt**: Verify domain DNS and letsencrypt-manager
- **Step CA**: Check step-ca-manager and virtual network config

## 📝 Notes

- The `build/` directory is automatically generated and should not be edited manually
- Environment variables in generated files use `$VARIABLE_NAME` format for proper interpolation
- Each generated configuration includes a complete `docker-compose.yml` and `.env.example`
- Missing `.env.*` files for components are handled gracefully by the build script

## 🔄 Migration from Legacy Deploy Script

The legacy `deploy.sh` script is still available for compatibility, but the new build system is recommended:

**Legacy approach:**

```bash
./deploy.sh --production --letsencrypt
```

**New approach:**

```bash
./build.sh
cd build/letsencrypt/guard/
cp .env.example .env
docker-compose up -d
