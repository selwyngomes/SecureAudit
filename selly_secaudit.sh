#!/bin/bash

LOG_FILE="sellyaudit.log"

log_message() {
  echo "$1" | tee -a "$LOG_FILE"
}

log_message "User and Group Audits:"
cut -d: -f1 /etc/passwd | tee -a "$LOG_FILE"
cut -d: -f1 /etc/group | tee -a "$LOG_FILE"
awk -F: '($3 == "0") {print "Root User: " $1}' /etc/passwd | tee -a "$LOG_FILE"
awk -F: '($2 == "" || $2 ~ /\$/) {print "Weak Password User: " $1}' /etc/shadow | tee -a "$LOG_FILE"

log_message "File and Directory Permissions:"
find / -type f -perm -o=w -exec ls -ld {} \; 2>/dev/null | tee -a "$LOG_FILE"
find / -type d -perm -o=w -exec ls -ld {} \; 2>/dev/null | tee -a "$LOG_FILE"
find /home -type d -name ".ssh" -exec ls -ld {} \; | tee -a "$LOG_FILE"
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -ld {} \; 2>/dev/null | tee -a "$LOG_FILE"

log_message "Service Audits:"
service --status-all 2>/dev/null | grep + | tee -a "$LOG_FILE"
for svc in sshd iptables; do
  systemctl is-active $svc &>/dev/null && log_message "$svc is running" || log_message "$svc is not running"
done

log_message "Firewall and Network Security:"
systemctl is-active ufw &>/dev/null && log_message "ufw is active" || log_message "ufw is not active"
netstat -tuln | tee -a "$LOG_FILE"
sysctl net.ipv4.ip_forward | tee -a "$LOG_FILE"

log_message "IP and Network Configuration Checks:"
ip addr show | tee -a "$LOG_FILE"

log_message "Security Updates and Patching:"
if command -v apt-get &>/dev/null; then
  apt-get update && apt-get -s upgrade | grep "^Inst" | tee -a "$LOG_FILE"
elif command -v yum &>/dev/null; then
  yum check-update | tee -a "$LOG_FILE"
fi

log_message "Log Monitoring:"
grep "Failed password" /var/log/auth.log | tee -a "$LOG_FILE"

log_message "Server Hardening Steps:"
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl reload sshd
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
apt-get install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades

log_message "Custom Security Checks:"
if [[ -f "security_config.cfg" ]]; then
  source "security_config.cfg"
  custom_security_checks
else
  log_message "No custom configuration file found."
fi

log_message "Audit complete. Summary report saved to $LOG_FILE."
