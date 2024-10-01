<VirtualHost *:443>
    # This block defines a VirtualHost for HTTPS traffic on port 443.

    ServerName pctr-q323-support-ui-httpd-1.dev.upto-gov
    # The domain name for this virtual host, which identifies it uniquely.
    # Traffic for this domain will be handled by this configuration.

    ## Vhost docroot
    DocumentRoot "/var/www/html"
    # The root directory where the website files are located.
    # In this case, it is set to "/var/www/html".

    <Directory "/var/www/html">
        # This block specifies directory-level configuration for "/var/www/html".

        Options FollowSymLinks
        # Allows the use of symbolic links in this directory.

        AllowOverride None
        # Prevents .htaccess files from overriding any configuration in this directory.
        
        Require all granted
        # Allows access to all clients (any IP addresses) without restrictions.

        RewriteEngine On
        # Enables the Apache mod_rewrite engine to handle URL rewriting.

        RewriteBase /supportui
        # The base URL for the rewritten rules, which defines where the relative paths start.
        # Here, the base path for the rewrites is "/supportui".
        # The commented line "# RewriteBase /" suggests that at one point, the base path may have been the root.

        # Rewrite rule to handle requests for "index.html"
        RewriteRule ^index\.html$ - [L]
        # This rule checks if the URL is "index.html". 
        # If true, the URL is not rewritten ("-") and this is the last rule to be applied ("L" flag).

        RewriteCond %{REQUEST_FILENAME} !-f
        # Checks if the requested filename does not exist as a regular file.

        RewriteCond %{REQUEST_FILENAME} !-d
        # Checks if the requested filename does not exist as a directory.

        # If the previous conditions are met (i.e., the request is neither for an existing file nor a directory),
        # redirect to "/supportui/index.html".
        RewriteRule ^ /supportui/index.html [L]

        # Another rewrite rule that redirects all requests to "/index.html" if no other condition is met.
        RewriteRule ^ /index.html [L]

    </Directory>
</VirtualHost>
