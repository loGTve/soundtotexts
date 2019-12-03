import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';


void main() => runApp(MainPage());



class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = " ";


  @override
  void initState() {
    super.initState();
    initSpeechRecognizer();
  }

  void initSpeechRecognizer(){
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result)
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
      (result) => setState(() => _isAvailable = result),
    );
  }


//UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  backgroundColor: Colors.pinkAccent, 
                  onPressed: () {
                    _speechRecognition.stop().then(
                      (result) => setState(() => _isListening =  result),
                    );
                  },
                  ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    if (_isAvailable && !_isListening)
                    _speechRecognition
                    .listen(locale: "ko_KR")
                    .then((result) => print('$result'));
                  },
                  ),
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if (_isListening)
                    _speechRecognition.cancel().then(
                      (result) => setState(() {
                        _isListening = result;
                        resultText = "";
                      }
                      ),
                    );
                  },
                  ),
              ],
            ),

            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                color: Colors.indigo[100], 
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              child: Text(
                resultText
              ),
            )

          ],
        ),
      ),
    );
  }
}