
/*
function __log(e, data) {
    log.innerHTML += "\n" + e + " " + (data || '');
  }
*/

  var audio_context;
  var recorder;
  var api_url;
  var input;

  function startUserMedia(stream) {
    input = audio_context.createMediaStreamSource(stream);
    //__log('Media stream created.');

    // Uncomment if you want the audio to feedback directly
    //input.connect(audio_context.destination);
    //__log('Input connected to audio context destination.');
    
    recorder = new Recorder(input);
    //__log('Recorder initialised.');
  }

  function startRecording(button) {
    recorder && recorder.record();
    button.disabled = true;
    button.nextElementSibling.disabled = false;
   // __log('Recording...');
  }

  function stopRecording(button) {
    recorder && recorder.stop();
    button.disabled = true;
    button.previousElementSibling.disabled = false;
   // __log('Stopped recording.');
    
    // create WAV download link using audio data blob
    createDownloadLink();
    
    recorder.clear();
    recorder = new Recorder(input);


  }

  function createDownloadLink() {
    recorder && recorder.exportWAV(function(blob) {
    
    $.ajax({
        type: "POST",
        url: api_url,
        data: blob,
        processData: false,
        contentType: blob.type

    });
      
      /*
      var li = document.createElement('li');
      var au = document.createElement('audio');
      var hf = document.createElement('a');
      
      au.controls = true;
      au.src = url;
      hf.href = url;
      hf.download = new Date().toISOString() + '.wav';
      hf.innerHTML = hf.download;
      li.appendChild(au);
      li.appendChild(hf);
      recordingslist.appendChild(li);
    */
    });
  }

  window.onload = function init() {
    try {
      // webkit shim
      window.AudioContext = window.AudioContext || window.webkitAudioContext;
      navigator.mozGetUserMedia = navigator.mozGetUserMedia || navigator.webkitmozGetUserMedia;
      window.URL = window.URL || window.webkitURL;
      
      audio_context = new AudioContext;

    //  __log('Audio context set up.');
    //  __log('navigator.mozGetUserMedia ' + (navigator.mozGetUserMedia ? 'available.' : 'not present!'));
    } catch (e) {
      alert('No web audio support in this browser!');
    }

    //MozmozGetUserMedia
    navigator.mozGetUserMedia({audio: true}, startUserMedia, function(e) {
      //__log('No live audio input: ' + e);
    });
  };