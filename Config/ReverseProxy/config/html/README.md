# HTML Sites
If the reverse proxy also serves static HTML sites, the root directories of each
can be placed here. Then in `../conf.d` add a file which points the domain to
the HTML web root, such as `/etc/nginx/html/www.website.name`. An example for
this exists called `html.example.com`. It should be fairly easy to recreate for
another website.
