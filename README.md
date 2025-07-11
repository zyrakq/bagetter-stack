# 🚀 BaGetter Stack

A comprehensive Docker stack for running BaGetter NuGet server with certificate management solutions.

## 📦 Components

### 🍰 BaGetter

**Location:** [`src/bagetter/`](src/bagetter/)

A lightweight NuGet and symbol server implementation. Perfect for hosting private NuGet packages with Docker support.

### 🔒 Let's Encrypt Manager

**Location:** [`src/letsencrypt-manager/`](src/letsencrypt-manager/)

Production-ready certificate management using Let's Encrypt for automatic SSL/TLS certificate provisioning and renewal in production environments.

### 🛡️ Step CA Manager  

**Location:** [`src/step-ca-manager/`](src/step-ca-manager/)

Self-signed certificate authority manager for virtual network deployments. Provides trusted certificates for internal/development environments without external dependencies.

## 🎯 Use Cases

- **🌐 Production Deployment**: Use BaGetter + Let's Encrypt Manager for public-facing NuGet servers
- **🏠 Internal Networks**: Use BaGetter + Step CA Manager for private/development environments
- **🔧 Development**: Use BaGetter standalone for local development

## 🚀 Quick Start

Each component has its own README with detailed setup instructions. Choose the certificate management solution that fits your deployment scenario.

## 📄 License

This project is dual-licensed under:

- [Apache License 2.0](LICENSE-APACHE)
- [MIT License](LICENSE-MIT)
