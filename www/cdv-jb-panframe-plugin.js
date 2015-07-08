var exec = require('cordova/exec');

var panframePlugin = {
	/*
	    params:
	    #1: video url
	    #2: view mode:  0 for spherical,
	                    1 for flat,
	                    2 for cylindrical,
	                    3 for side-by-side VR (non-stereoscopic),
	                    4 for top-down VR formatted content (stereoscopic).
	*/
    init: function(videoUrl, viewMode, successCallback, errorCallback) {
        exec(
            successCallback,
            errorCallback,
            'PanframePlugin',
            'init',
            [videoUrl, viewMode]
        );
    }
};

module.exports = panframePlugin;