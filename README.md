This is example of Nginx using for custom Keycloak authorization.

For running locally use follow commands: 

```
git clone https://github.com/bocharoviliyav/nginx-lua-keycloak-example.git
cd nginx-lua-keycloak-example/nginx-consumer
mvn clean package
docker build -t nginx/consumer:1 .
cd ..
cd nginx-lua-gateway
docker build -t nginx:1 .
cd ..
docker network create mybridge
docker-compose up
```