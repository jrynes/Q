<VirtualHost *:443>
    ServerName pctr-q323-support-ui-httpd-1.dev.upto-gov

    DocumentRoot "/var/www/html/supportui"
    
    <Directory "/var/www/html/supportui">
        Options FollowSymLinks
        AllowOverride None
        Require all granted

        RewriteEngine On
        RewriteBase /

        RewriteRule ^index\.html$ - [L]
        # Do not rewrite index.html itself.

        # Exclude static assets like .js, .css, .png, .jpg, .gif, .ico, etc. from being rewritten.
        RewriteCond %{REQUEST_URI} !\.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|eot|ttf|otf)$ [NC]
        
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule ^ /supportui/index.html [L]
        # Rewrite all other requests that are not files or directories to /supportui/index.html.
    </Directory>
</VirtualHost>
