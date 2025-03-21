#cloud-config
package_update: true
packages:
  - nginx
runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - echo "Bienvenue sur mon site depuis $(hostname) <br/>" >> /var/www/html/index.html
  - echo "<img src='${image_url}' alt='mon image'/>" >> /var/www/html/index.html

