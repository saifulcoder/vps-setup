# LAMP Stack Installation Script

## Overview
This Bash script automates the installation of a LAMP (Linux, Apache, MySQL/MariaDB, PHP) stack along with additional tools like FFmpeg, Node.js, and Composer. It is designed for Ubuntu-based systems and simplifies the setup process for web development environments.

## Features
- **System Update**: Automatically updates the system packages.
- **Apache Installation**: Installs and configures the Apache web server.
- **MariaDB Installation**: Installs MariaDB and prompts for secure installation.
- **PHP Installation**: Allows the choice between PHP 7.4 and PHP 8.3 and installs core and optional PHP extensions.
- **FFmpeg Installation**: Installs FFmpeg for multimedia processing.
- **Node.js Installation**: Installs Node.js version 20.
- **Composer Installation**: Installs Composer for PHP dependency management.
- **Default Web Page**: Sets up a default web page for the server.
- **Apache Configuration**: Configures Apache to serve the default page.

## Prerequisites
- A system running Ubuntu or a compatible Debian-based distribution.
- Sudo privileges to install packages and modify system configurations.

## Usage
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/saifulcoder/vps-setup.git
   cd vps-setup
   ```

2. **Make the Script Executable**:
   ```bash
   chmod +x install_lamp.sh
   ```

3. **Run the Script**:
   ```bash
   ./install_lamp.sh
   ```

4. **Post-Installation**:
   After the script completes, run the following command to secure your MariaDB installation:
   ```bash
   sudo mysql_secure_installation
   ```

## Script Breakdown
- **Error Handling**: The script includes a function to handle errors gracefully.
- **Package Installation**: Uses `apt` to install necessary packages and handle dependencies.
- **PHP Extensions**: Installs both core and optional PHP extensions based on availability.
- **Apache Configuration**: Sets up a virtual host for serving web content.

## Important Notes
- Ensure your system is connected to the internet during the installation process.
- Some optional PHP extensions may not be available depending on your system's repositories.
- The script will prompt you to run `mysql_secure_installation` manually to secure your MariaDB installation.

## Verification
After installation, you can verify the installations by checking the versions of the installed software:
```bash
apache2 -v
mysql --version
php -v
node -v
npm -v
composer -V
```

## Adding a New Domain
After installing the LAMP stack, you can add a new domain to your server by following these steps:

```bash
chmod +x vhost.sh
```
Run the Script: Execute the script as root or with sudo:
bash

```bash
sudo ./vhost.sh
```

Enter Domain Name: When prompted, enter the domain name you want to add (e.g., example.com).
Choose Protocol: Select between http or https according to your needs.
Done: After the script finishes running, your new domain will be added to the Apache configuration. If you chose HTTPS, make sure to configure the SSL certificate correctly.


## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing
Feel free to submit issues or pull requests for improvements or bug fixes. Your contributions are welcome!

## For Improvement and project

contact us saiful.coder@gmail.com

## Contributing

This project helps you and you want to help keep it going? Buy me a coffee:
<br> <a href="https://www.buymeacoffee.com/saifulcoder" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 61px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" ></a><br>
or via <br>
<a href="https://saweria.co/saifulcoder">https://saweria.co/saifulcoder</a>
