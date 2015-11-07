var exec = require('cordova/exec');

var panframePlugin = {
	/*
	    params:
	    #1: video url
	    #2: view mode:(iOS)
						0 for spherical,
	                    1 for flat,
	                    2 for cylindrical,
	                    3 for side-by-side VR (non-stereoscopic),
	                    4 for top-down VR formatted content (stereoscopic).
	    			  Android:
	    				0 for spherical,
	    				1 for flat display,
	    				2 for stereo side-by-side
	*/

    init: function(videoUrl, viewMode, aspectRatio, successCallback, errorCallback) {
        exec(
            successCallback,
            errorCallback,
            'PanframePlugin',
            'init',
            [videoUrl, viewMode, aspectRatio]
        );
    }
};

module.exports = panframePlugin;