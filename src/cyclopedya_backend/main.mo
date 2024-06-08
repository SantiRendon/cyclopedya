import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Types "Types";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
actor {
  public query func greet(name : Text) : async Text {
    return "Hello, " # name # "!";
  };

  //0. method that uses the HTTP outcalls feature and returns a string
  public func get_book_info(isbn : Text) : async Text {

    //1. DECLARE MANAGEMENT CANISTER
    let ic : Types.IC = actor ("aaaaa-aa");

    //2. SETUP ARGUMENTS FOR HTTP GET request
    let host : Text = "openlibrary.org";
    let url = "https://" # host # "/search.json?q=" # isbn;

    let request_headers = [];

    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    let request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; //optional for request
      headers = request_headers;
      body = null; //optional for request
      method = #get;
      transform = ?transform_context;
    };

    //3. ADD CYCLES TO PAY FOR HTTP REQUEST
    Cycles.add(20_000_000_000);

    //4. MAKE HTTPS REQUEST AND WAIT FOR RESPONSE
    let response : Types.HttpResponsePayload = await ic.http_request(request);

    //5. DECODE THE RESPONSE
    let response_body : Blob = Blob.fromArray(response.body);
    let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };
    //6. RETURN RESPONSE OF THE BODY
    decoded_text;
  };

  public func get_book_urls(isbn : Text) : async Text {

    let ic : Types.IC = actor ("aaaaa-aa");

    let host : Text = "openlibrary.org";
    let url = "https://" # host # "/api/books?bibkeys=ISBN:" # isbn # "&format=json";

    let request_headers = [];

    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    let request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; //optional for request
      headers = request_headers;
      body = null; //optional for request
      method = #get;
      transform = ?transform_context;
    };

    Cycles.add(20_000_000_000);

    let response : Types.HttpResponsePayload = await ic.http_request(request);

    let response_body : Blob = Blob.fromArray(response.body);
    let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };

    decoded_text;
  };

  //7. CREATE TRANSFORM FUNCTION
  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
    let transformed : Types.CanisterHttpResponsePayload = {
      status = raw.response.status;
      body = raw.response.body;
      headers = [
        {
          name = "Content-Security-Policy";
          value = "default-src 'self'";
        },
        { name = "Referrer-Policy"; value = "strict-origin" },
        { name = "Permissions-Policy"; value = "geolocation=(self)" },
        {
          name = "Strict-Transport-Security";
          value = "max-age=63072000";
        },
        { name = "X-Frame-Options"; value = "DENY" },
        { name = "X-Content-Type-Options"; value = "nosniff" },
      ];
    };
    return transformed;
  };
};
