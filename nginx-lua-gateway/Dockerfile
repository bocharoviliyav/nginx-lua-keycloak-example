FROM openresty/openresty:1.19.3.1-2-alpine-fat
EXPOSE 8081

COPY nginx.conf    /usr/local/openresty/nginx/conf
COPY convertor.lua /usr/local/openresty/lualib
COPY json.lua     /usr/local/openresty/lualib

RUN /usr/local/openresty/luajit/bin/luarocks install lua-resty-http

