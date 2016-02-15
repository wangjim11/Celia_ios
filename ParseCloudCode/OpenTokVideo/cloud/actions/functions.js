var opentok = require("cloud/opentok/opentok.js").createOpenTokSDK("45491612", "0f2e91414959869b342abbebba4f747d55cd9fc3");


Parse.Cloud.define("createCamera", function(request, response) {
    var user = request.user;
    if (!user) {
        response.error("Login before creating camera");
        return;
    }
        
    var camera = new Parse.Object("Camera");
    
    var cameraName = request.params.name;
    if (cameraName) {
        camera.set("name", cameraName);
    }

    var cameraUID = request.params.iosUID;
    if (cameraUID) {
        camera.set("iosUID", cameraUID);
    }
    
  	opentok.createSession(function(err, sessionId) {
		if (err) { 
			response.error("could not create opentok session for camera: " + camera.id); 
			return;
		}		
		camera.set("optSessionID", sessionId);
		
		camera.save().then(function(camera) {
			response.success(camera);
    	});
	}); 	
});


Parse.Cloud.define("getOpentokToken", function(request, response) {
	var cameraId = request.params.camera;
	if (!cameraId) response.error("you must provide a camera object id");
	var cameraQuery = new Parse.Query("Camera");
	cameraQuery.get(cameraId, {	
		success: function(camera) {
			var role = "subscriber";
			if (request.params.isPublisher==true) {
				role = "publisher";
			}
			var options = {"expireTime" : (new Date().getTime()/1000)+3600, // in one hour
							"role"		: role};
			var token = opentok.generateToken(camera.get("optSessionID"), options);
			if (token) {
				response.success(token);
			} else {
				response.error("could not generate token for camera id: " + cameraId + " for role: subscriber");
			}
		},
	
		error: function(camera, error) {
			response.error("cannot find camera with id: " + cameraId);
		}
	});
});
