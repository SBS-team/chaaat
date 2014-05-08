//$(document).ready(function(){
//
//    var config = {
//        openSocket: function(config) {
//            // http://socketio-over-nodejs.hp.af.cm/
//            // http://socketio-over-nodejs.jit.su:80/
//            // http://webrtc-signaling.jit.su:80/
//
//            var SIGNALING_SERVER = 'http://webrtc-signaling.jit.su:80/',
//                defaultChannel = location.hash.substr(1);
//
//            var channel = config.channel || defaultChannel;
//            var sender = Math.round(Math.random() * 999999999) + 999999999;
//
//            io.connect(SIGNALING_SERVER).emit('new-channel', {
//                channel: channel,
//                sender: sender
//            });
//
//            var socket = io.connect(SIGNALING_SERVER + channel);
//            socket.channel = channel;
//
//            socket.on('connect', function() {
//                if (config.callback) config.callback(socket);
//            });
//
//            socket.send = function(message) {
//                socket.emit('message', {
//                    sender: sender,
//                    data: message,
//                    t: "tttttt"
//                });
//            };
//
//            socket.on('message', config.onmessage);
//
//            socket.on('message', function(data){
//              console.log(data.my_id);
//            });
//        },
//        onRemoteStream: function(media) {
//
//
//            var video = media.video;
//            video.setAttribute('controls', true);
//            video.setAttribute('id',media.user_id);//somebody else
//            console.log("id "+ window.my_id);
//            videosContainer.insertBefore(video, videosContainer.firstChild);
//            video.play();
//        },
//        onRemoteStreamEnded: function(stream) {
//            var video = document.getElementById(stream.id);
//            if (video) video.parentNode.removeChild(video);
//        },
//        onRoomFound: function(room) {
//
//                captureUserMedia(function() {
//                    conferenceUI.joinRoom({
//                        roomToken: room.broadcaster,
//                        joinUser: room.broadcaster,
//                        my_id: gon.user_id
//                    });
//                });
//
//        }
//    };
//
//
//    var conferenceUI = conference(config);
//    var videosContainer = document.getElementById('videos-container') || document.body;
//    var roomsList = document.getElementById('rooms-list');
//
//    document.getElementById('setup-new-room').onclick = function () {
//        alert();
//        this.disabled = true;
//        captureUserMedia(function () {
//            conferenceUI.createRoom({
//                roomName: gon.user_login
//            });
//        });
//    };
//
//    function captureUserMedia(callback) {
//        var check_video = document.getElementById("me");
//        if (!check_video){
//        var video = document.createElement('video');
//        video.setAttribute('autoplay', true);
//        video.setAttribute('controls', true);
//        video.setAttribute('id', "me");//you
//        videosContainer.insertBefore(video, videosContainer.firstChild);
//        getUserMedia({
//            video: video,
//            onsuccess: function (stream) {
//                config.attachStream = stream;
//
//                video.setAttribute('muted', true);
//                callback();
//            }
//        });
//    }
//    }
//
//
//
//
//
//
//
//});