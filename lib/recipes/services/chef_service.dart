// chef_service.dart

import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ChefService {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  MediaStream? _localStream;
  String ephemeralKey = "";
  bool _isSessionActive = false;

  Future<void> startChatSession() async {
    if (_isSessionActive) {
      await stopChatSession();
    }
    
    _isSessionActive = true;
    await _fetchEphemeralToken();
    await _initializeWebRTCConnection();
  }

  Future<void> _fetchEphemeralToken() async {
    try {
      final url = "https://session-d32yr3oc6a-uc.a.run.app";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ephemeralKey = data["client_secret"]["value"];
      } else {
        throw Exception("Failed to fetch ephemeral token. Status: ${response.statusCode}");
      }
    } catch (error) {
      // TODO: handle and log somewhere?
    }
  }

  Future<void> _initializeWebRTCConnection() async {
    final config = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"}
      ]
    };

    // create peer connection
    _peerConnection = await createPeerConnection(config);
    
    // Capture user audio
    try {
      _localStream = await navigator.mediaDevices.getUserMedia({"audio": true});
    } catch (e) {
      return;
      // TODO: handle and log somewhere?
    }
    // add tracks to peer connection
    _localStream!.getTracks().forEach((track) {
      _peerConnection!.addTrack(track, _localStream!);
    });

    // Handle remote audio
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      // do nothing
    };

    // Create a data channel for server events
    RTCDataChannelInit dataChannelInit = RTCDataChannelInit();
    _dataChannel = await _peerConnection!.createDataChannel("oai-events", dataChannelInit);
    _dataChannel!.onMessage = (RTCDataChannelMessage message) {
      final serverEvent = jsonDecode(message.text);
      //print("Received server event: $serverEvent"); // incase you want to see the events
    };
    
    // Send the SDP offer to start the session
    final offer = await _peerConnection!.createOffer({
      "offerToReceiveAudio": true,
    });
    await _peerConnection!.setLocalDescription(offer);
    await _sendSDPOffer(offer.sdp ?? "");
  }

  Future<void> sendEvent(String text) async {
    if (_dataChannel != null) {
      final event = {
        "type": "response.create",
        "response": {"modalities": ["text"], "instructions": text},
      };
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode(event)));
    }
  }

  Future<void> _sendSDPOffer(String offerSdp) async {
    final url = Uri.parse("https://api.openai.com/v1/realtime?model=gpt-4o-realtime-preview");

    try {
      // Create a raw HTTP client
      final client = HttpClient();
      final request = await client.postUrl(url);

      // Set headers
      request.headers.set(HttpHeaders.authorizationHeader, "Bearer $ephemeralKey");
      request.headers.set(HttpHeaders.contentTypeHeader, "application/sdp");

      // Add the SDP offer as the body
      request.write(offerSdp);

      // Send the request
      final response = await request.close();

      // Read the response
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 201) {
        final answer = RTCSessionDescription(responseBody, "answer");
        await _peerConnection!.setRemoteDescription(answer);
      } else {
        // TODO: handle and log somewhere?
        //print("Failed to receive SDP answer. Status: ${response.statusCode}");
      }

      client.close();
    } catch (e) {
      // TODO: handle and log somewhere?
      //print("Error sending SDP offer: $e");
    }
  }

  Future<void> stopChatSession() async {
  try {
    // 1. Close data channel first
    if (_dataChannel != null) {
      _dataChannel?.onMessage = null;
      await _dataChannel?.close();
      _dataChannel = null;
    }

    // 2. Stop and cleanup local media
    if (_localStream != null) {
      final tracks = List.from(_localStream!.getTracks()); // Create a copy of tracks list
      for (var track in tracks) {
        try {
          await track.stop();
        } catch (e) {
          // TODO: handle and log somewhere?
          //print("Error stopping track: $e");
        }
      }
      await _localStream?.dispose();
      _localStream = null;
    }

    // 3. Clean up peer connection
    if (_peerConnection != null) {
      // Remove event listeners
      _peerConnection!.onIceCandidate = null;
      _peerConnection!.onIceConnectionState = null;
      _peerConnection!.onConnectionState = null;
      _peerConnection!.onTrack = null;
      
      try {
        await _peerConnection!.close();
      } catch (e) {
        // TODO: handle and log somewhere?
        //print("Error closing peer connection: $e");
      }
      
      try {
        await _peerConnection!.dispose();
      } catch (e) {
        // TODO: handle and log somewhere?
        //print("Error disposing peer connection: $e");
      }
      
      _peerConnection = null;
    }

    } catch (e) {
      // TODO: handle and log somewhere?
      //print("Error during session cleanup: $e");
      rethrow;
    }
  }
}