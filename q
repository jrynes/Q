<VirtualHost *:443>
    ServerName pctr-q323-support-ui-httpd-1.dev.upto-gov

    ## Vhost docroot
    DocumentRoot "/var/www/html/supportui"
    # Set the document root directly to the supportui folder where your Angular app is located.

    <Directory "/var/www/html/supportui">
        Options FollowSymLinks
        AllowOverride None
        Require all granted

        RewriteEngine On
        RewriteBase /
        # Set the base URL to the root ("/") so that all requests will be handled as if the app is at the root.

        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        # If the requested resource is not a file or directory, redirect to index.html.

        RewriteRule ^ /index.html [L]
        # This ensures that requests to any path (except valid files or directories) will be served with index.html.
    </Directory>
</VirtualHost>
