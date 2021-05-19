vcl 4.0;

backend default {
    .host = "api-catalog";
    .port = "6070";
    .connect_timeout = 60s;
    .first_byte_timeout = 60s;
	.between_bytes_timeout = 60s;
	.max_connections = 800;
}

sub vcl_deliver {
  # Display hit/miss info
  if (obj.hits > 0) {
    set resp.http.V-Cache = "HIT";
  }
  else {
    set resp.http.V-Cache = "MISS";
  }
  set resp.http.Access-Control-Allow-Origin = "*";
  set resp.http.Allow = "GET";
  set resp.http.Access-Control-Allow-Methods = "GET";
}
sub vcl_backend_response {
  if (beresp.status == 200) {
    unset beresp.http.Cache-Control;
    set beresp.http.Cache-Control = "public; max-age=300";
    set beresp.ttl = 300s;
  }
  set beresp.http.Served-By = beresp.backend.name;
  set beresp.http.V-Cache-TTL = beresp.ttl;
  set beresp.http.V-Cache-Grace = beresp.grace;
}
