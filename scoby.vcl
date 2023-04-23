import digest;

sub vcl_deliver {
    declare local var.apiKey STRING;
    set var.apiKey = "your_base64_encoded_api_key";

    declare local var.salt STRING;
    set var.salt = "your_salt_value";

    declare local var.workspaceId STRING;
    declare local var.writeKey STRING;

    set var.workspaceId = digest.base64url_decode(var.apiKey);
    set var.workspaceId = regsub(var.workspaceId, "\\|.*$", "");

    set var.writeKey = digest.base64url_decode(var.apiKey);
    set var.writeKey = regsub(var.writeKey, "^[^|]*\\|", "");

    # Create visitorId
    declare local var.visitorId STRING;
    set var.visitorId = digest.sha256(client.ip req.http.User-Agent var.workspaceId var.salt);

    # Get requestedUrl
    declare local var.requestedUrl STRING;
    set var.requestedUrl = regsuball(req.url, "(?:(\?)|&)(?!(utm_source|utm_medium|utm_campaign|utm_content|utm_term)=)[^&]+", "\1");

    # Get referringUrl
    declare local var.referringUrl STRING;
    if (req.http.Referer) {
        set var.referringUrl = regsub(req.http.Referer, "^(https?://[^/]+).*", "\1");
    }

    # Build request URL
    declare local var.loggingEndpointUrl STRING;
    set var.loggingEndpointUrl = "https://" var.workspaceId ".s3y.io/count?"?vid=" + urlencode(var.visitorId) + "&url=" + urlencode(var.requestedUrl) + "&ua=" + urlencode(req.http.User-Agent);

    if (var.referringUrl) {
        set var.loggingEndpointUrl = var.loggingEndpointUrl + "&ref=" + urlencode(var.referringUrl);
    }

    # Send the request to the logging endpoint
    http req.url = var.loggingEndpointUrl;
    http req.method = "GET";
    http_req_send(main.backend(), req.url, req.http.host, req.http.User-Agent, req.http.Referer, req.http.Accept, req.http.Accept-Language);
}