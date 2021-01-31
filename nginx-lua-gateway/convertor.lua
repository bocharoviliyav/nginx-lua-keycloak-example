local log = ngx.log
local ERR = ngx.ERR

return function()

    local customCache = ngx.shared.custom_cache

    local protocol = os.getenv("protocol")
    local url = os.getenv("url")
    local port = os.getenv("port")
    local keycloakUrl = protocol .. "://" .. url .. ":" .. port

    local realm = ngx.req.get_headers()["realm"]
    local client = ngx.req.get_headers()["clientId"]
    local secret = ngx.req.get_headers()["secret"]

    --[[
        Or You can use Basic Auth with additional realm header:
        local authorization = ngx.var.http_authorization
        local basicAuthHeaderInBase64 = string.sub(authorization, 7)
        local basic = ngx.decode_base64(basicAuthHeaderInBase64)
        local clientIdFunc = string.gmatch(basic, '([^:]+)')
        local clientSecretFunc = string.gmatch(basic, '([^:]+)$')
        local client = clientIdFunc()
        local secret = clientSecretFunc()
        local realm = ngx.req.get_headers()["realm"] ]] --

    local clientIdentity = realm .. client .. secret

    local http = require "resty.http"
    local httpClient = http.new()

    local response
    local err

    -- Get custom cache storage key=basic pair value= bearer token

    -- Get token from cache
    local accessTokenFromCache = customCache:get(clientIdentity)
    if accessTokenFromCache ~= nil then
        local bearerHeaderFromCache = string.format("Bearer %s", accessTokenFromCache)
        -- Get user info to token validation

        response, err = httpClient:request_uri(keycloakUrl ..
                '/auth/realms/' .. realm .. '/protocol/openid-connect/userinfo', {
            method = "GET",
            headers = {
                ["Authorization"] = bearerHeaderFromCache,
            }
        })
    end
    -- If response not exists or status not equals to 200 get new token and set into cache
    if not response or response.status ~= 200 then
        log(ERR, "Failed to validate token from cache: ", err)
        log(ERR, "clientId: ", client)
        response, err = httpClient:request_uri(keycloakUrl ..
                '/auth/realms/' .. realm .. '/protocol/openid-connect/token', {
            method = "POST",
            body = ngx.encode_args({
                client_id = client,
                grant_type = 'client_credentials',
                client_secret = secret
            }),
            headers = {
                ["Content-Type"] = "application/x-www-form-urlencoded",
            }
        })

        if not response then
            log(ERR, "Failed to get token, response is not exist: ", err)
            return
        elseif response.status ~= 200 then
            log(ERR, "Failed to get token, status=", response.status, response.body)
            return
        end

        local json = require "json"

        local newAccessToken = json.decode(response.body)['access_token']

        -- Set new token
        customCache = ngx.shared.custom_cache
        customCache:set(clientIdentity, newAccessToken)
    end
    -- always get from cache
    customCache = ngx.shared.custom_cache
    local accessToken = customCache:get(clientIdentity)

    local bearerHeader = string.format("Bearer %s", accessToken)
    ngx.req.set_header("Authorization", bearerHeader)

    ngx.req.clear_header("clientId")
    ngx.req.clear_header("secret")
    ngx.req.clear_header("realm")
end
