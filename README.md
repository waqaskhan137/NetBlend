## NetBlend VPN Service Installer

This documentation provides step-by-step instructions for installing the NetBlend VPN service using the provided installation script. The script automates the installation process and uses OpenConnect and vpn-slice to set up and manage the VPN connection.

### Prerequisites

Before proceeding with the installation, ensure that you have the following:

1. Linux-based operating system (e.g., Ubuntu, CentOS, Fedora)
2. Administrative privileges (sudo access) to install packages and modify system files

### Installation Steps

Follow these steps to install and configure the NetBlend VPN service:

1. Open a terminal window on your Linux system.

2. Download the installation script:
   ```bash
   wget https://raw.githubusercontent.com/waqaskhan137/NetBlend/main/netblend-vpn-installer.sh
   ```

3. Make the script executable:
   ```bash
   chmod +x netblend-vpn-installer.sh
   ```

4. Run the installation script:
   ```bash
   ./netblend-vpn-installer.sh
   ```

5. The installation script will prompt you to provide the following information:

   - **Company Name**: Enter the name of your company for which the NetBlend VPN service is being installed.

   - **Main Password**: Enter your main password for authentication.

   - **Company Password**: Enter your NetBlend password associated with the VPN connection.

   - **Main User**: Enter the main username for the VPN connection.

   - **OTP Secret**: Enter the OTP (One-Time Password) secret for two-factor authentication.

   - **Initial Company IPs**: Enter the initial IP addresses or subnets that should be included in the VPN slice. Separate multiple IPs or subnets with a space.

6. The installation script will proceed with the following actions:

   - Check for the presence of OpenConnect and install it if necessary. OpenConnect is used to establish the VPN connection. Follow the instructions in the OpenConnect documentation for installation details specific to your Linux distribution.

   - Check for the presence of Python and install it if necessary. Python is required to run the installation script. Refer to your Linux distribution's package manager to install Python.

   - Check for the presence of vpn-slice and install it if necessary. vpn-slice is used to manage the VPN slice and route specific IP ranges through the VPN connection. Follow the instructions in the vpn-slice documentation for installation details specific to your Linux distribution.

   - Generate a VPN script based on the provided input. The script contains the necessary environment variables and commands to establish the VPN connection using OpenConnect and vpn-slice.

   - Create a systemd service unit file named `netblend.service` for the NetBlend VPN service, which ensures the service is automatically started and managed by the system.

   - Enable and start the NetBlend VPN service using the following commands:
     ```bash
     sudo systemctl enable netblend.service
     sudo systemctl start netblend.service
     ```

   - Create an alias (`vpn-ips`) in the user's `.bashrc` file for managing the company IPs. This alias allows adding or removing IPs from the VPN slice dynamically. Source the `.bashrc` file to activate the alias.

7. Once the installation completes successfully, you can start and stop the NetBlend VPN service using the following commands:
   ```bash
   sudo systemctl start netblend.service    # Start the NetBlend VPN service
   sudo systemctl stop netblend.service     # Stop the NetBlend VPN service
   sudo systemctl restart netblend.service  # Restart the NetBlend VPN service
   sudo systemctl status netblend.service   # Check the status of the NetBlend VPN service
   ```

8. To add or remove IPs from the VPN slice, use the `vpn-ips` alias in

 the terminal:
   ```bash
   vpn-ips
   ```
   This command will prompt you to enter the IP address or subnet you want to add or remove.

### Additional Resources

- [OpenConnect Documentation](https://www.infradead.org/openconnect/)
- [vpn-slice Documentation](https://pypi.org/project/vpn-slice/)

Refer to the official documentation for OpenConnect and vpn-slice for more information on their usage, configuration options, and advanced features.

You have now successfully installed and configured the NetBlend VPN service on your Linux system. Enjoy secure and private browsing with your company's VPN connection!

Please note that this documentation assumes basic familiarity with Linux terminal commands and system administration tasks. If you encounter any issues during the installation process or have specific requirements, refer to the official documentation of the involved tools or seek further assistance.