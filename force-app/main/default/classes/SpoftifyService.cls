public with sharing class SpoftifyService {
    //Integration happens in two phase --> getAccessToken, getDetails using that access token
    public static String getSpotifyAccessToken(){
        String tokenUrl = 'https://accounts.spotify.com/api/token';
        
        // Base64 encoding of Client ID and Client Secret
        String clientId = '13f5ff65a5d549078dce74d2a17307f5';
        String clientSecret = 'ce43da808bb64a37adc6aed628af5a07';
        String authHeader = EncodingUtil.base64Encode(Blob.valueOf(clientId + ':' + clientSecret));

        // Preparing the request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(tokenUrl);
        req.setHeader('Authorization','Basic ' + authHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials');

        // Send request and get the response
        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200){
            System.debug(res.getBody());
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            return (String) result.get('access_token');
        }
        else{
            throw new CalloutException('Error retrieving access token. Status: ' + res.getStatus());
        }

    }

    public static String getArtistDetails(String artistId){

        String endPoint = 'https://api.spotify.com/v1/artists/' + artistId;
        String accessToken = getSpotifyAccessToken();

        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endPoint);
        req.setHeader('Authorization','Bearer '+accessToken);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if(res.getStatusCode() == 200){
            return res.getBody();
        }
        else{
            throw new CalloutException('Error retrieving artist information. Status: ' + res.getStatus());
        }
    }
}