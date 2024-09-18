```markdown
# VPS setup LAMP (LINUX APACHE MYSQL PHP)

## Description

This script is designed for installing PHP addons and other software on a Debian 11 64-bit VPS. The script installs the following:

- PHP version 7.4
- MariaDB version 10
- Composer
- Node.js version 20
- FFmpeg
- PHP addons including:
  - Imagick
  - Fileinfo
  - IMAP
  - LDAP
  - Phalcon
  - Yaf
  - Redis
  - Memcached
  - Memcache
  - Xdebug

## Requirements

- Debian 11 64-bit VPS with root access
- Ondrej PPA repository for PHP

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/username/php-addons-installer.git
   cd php-addons-installer
   ```

2. **Run the script**:

   ```bash
   sudo bash install.sh
   ```

   This script will install all the mentioned PHP addons and other software.

## Additional Configuration

Some addons like Phalcon and Yaf may require additional configuration after installation. Please refer to the [official Phalcon documentation](https://docs.phalcon.io) and the [official Yaf documentation](https://www.php.net/manual/en/book.yaf.php) for further configuration steps if needed.

The script uses the Ondrej PPA repository for PHP, which allows the installation of newer PHP versions and additional addons.

## Verification

After running the script, it is recommended to check if all addons have been installed correctly using the following command:

```bash
php -m
```

To use Xdebug, you may need to configure it further in the `php.ini` file.

## Notes

- Make sure to review the script and understand it before running it on your system. If you are unsure, always consult with a system administrator or IT professional.
- If you encounter issues with installing certain addons, you may need to install them manually or look for additional repositories.

## License

Specify the license applicable to this script (e.g., MIT License).

```

Feel free to adjust the GitHub URL or license information as needed.
