
# SecureAudit: Automated Linux Security Audit and Hardening Script

SecureAudit is a comprehensive Bash script designed for automating security audits and hardening processes on Linux servers. This script provides a modular approach to ensure your servers meet stringent security standards by performing the following tasks




## Features

- User and Group Audits: Lists all users and groups, checks for root privileges and weak passwords.

- File and Directory Permissions: Scans for world-writable files and directories, verifies .ssh permissions, and identifies files with SUID/SGID bits set.

- Service Audits: Checks the status of critical services and ensures no unauthorized services are running.

- Firewall and Network Security: Verifies firewall status, reports open ports, and checks IP forwarding configurations.

- IP and Network Configuration Checks: Identifies public vs. private IP addresses and ensures sensitive services are not exposed unnecessarily.

- Security Updates and Patching: Checks for available security updates and ensures regular update configurations.

- Log Monitoring: Monitors for suspicious log entries such as failed SSH login attempts.
- Server Hardening Steps: Implements key security measures including SSH key-based authentication, IPv6 disabling, and automatic updates.
- Custom Security Checks: Allows easy extension with custom checks through a configuration file.



## Deployment

To deploy SellySecure on your Linux server, follow these steps:

1. Clone the Repository

```bash
  git clone https://github.com/selwyngomes/SecureAudit.git
  cd your-repository
```
2. Make the Script Executable: Before running the script, ensure it is executable by running:

```bash
  chmod +x selly_secaudit.sh
```
3. Run the Script
```bash
  ./selly_secaudit.sh
```
4. Review the Log File
```bash
  cat selly_secaudit.sh
```
5. Custom Security Checks
- If you need custom security checks, create a security_config.cfg file in the same directory as the script. This file can include additional checks you want to perform.
6. Automatic Updates Configuration
- To ensure your server receives and installs security updates automatically, configure unattended-upgrades:
```bash
   apt-get install -y unattended-upgrades
   dpkg-reconfigure --priority=low unattended-upgrades
```
7. Customizing Hardening Measures
- If you need to customize specific hardening measures (e.g., firewall rules or SSH settings), edit the script directly or update the configuration files used by the script.
8. Scheduled Runs (Optional)
- To automate the running of the script, consider adding it to a cron job. For example, to run the script daily at midnight:
```bash
   crontab -e
```
- Add the following line to the crontab file:
```bash
0 0 * * * /path/to/your-repository/selly_secaudit.sh
```
- Replace /path/to/your-repository/ with the path where you cloned the repository.

- By following these steps, you will have SellySecure set up and running on your Linux server, helping to ensure its security and compliance with best practices.




## Contributing

- Contributions are always welcome!

- If you have suggestions for improving the script, feel free to create a pull request or open an issue on GitHub.


## License

[MIT](https://choosealicense.com/licenses/mit/)

