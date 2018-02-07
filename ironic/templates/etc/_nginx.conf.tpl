user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    server {
      listen       OSH_PXE_IP:{{ tuple "baremetal" "internal" "pxe_http" . | include "helm-toolkit.endpoints.endpoint_port_lookup" }};
      server_name  localhost;

      #charset koi8-r;
      #access_log  /var/log/nginx/host.access.log  main;

      location / {
          root   /var/lib/openstack-helm/httpboot;
      }
    }
}
