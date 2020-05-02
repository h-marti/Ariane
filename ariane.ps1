[void][System.Reflection.Assembly]::LoadWithPartialName("System.Speech");

##Setup the speaker, this allows the computer to talk
$speaker = [System.Speech.Synthesis.SpeechSynthesizer]::new();
$speaker.SelectVoice("Microsoft Hortense Desktop");

##Setup the Speech Recognition Engine, this allows the computer to listen
$speechRecogEng = [System.Speech.Recognition.SpeechRecognitionEngine]::new();

##Setup the verbal commands
# (<voice_input>,<voice_output>,<command>,<arguments>)
$a = ("Ariane", "Bonjour Monsieur","echo","Bonjour")
$b = ("Sortie","A bientot monsieur","endOfLine","")
$c = ("Disco","Let's dance","C:\Program Files\Mozilla Firefox\firefox.exe","https://www.youtube.com/watch?v=n0xJehv5Fag")
$d = ("GitHub","Voyons à quoi ressemble ce code","C:\Program Files\Firefox Developer Edition\firefox.exe","https://github.com/")
$e = ("Code", "Bon travail monsieur","D:\Programmes\Microsoft VS Code\Code.exe","")
$f = ("Spotify", "Je sors mes platines","spotify","")
$g = ("Quitter", "fermeture en cours","./close.ps1","")

$elements = $a,$b,$c,$d,$e,$f,$g

foreach ($grammar in $elements) {
    ${$grammar[0]} = [System.Speech.Recognition.GrammarBuilder]::new() ;
    ${$grammar[0]}.Append($grammar[0]);
    $speechRecogEng.LoadGrammar(${$grammar[0]});
}


$speechRecogEng.InitialSilenceTimeout = 15
$speechRecogEng.SetInputToDefaultAudioDevice();
$cmdBoolean = $true;

while ($cmdBoolean) {
    $speechRecognize = $speechRecogEng.Recognize();
    $conf = $speechRecognize.Confidence;

    $voiceInput = $speechRecognize.text;

    foreach ($grammar in $elements) {
        if ($voiceInput -match $grammar[0] -and [double]$conf -gt 0.85) {

            $speaker.Speak($grammar[1]);

            if ($grammar[2] -eq "endOfLine") {
                $cmdBoolean=$false
            }else{
                & $grammar[2] $grammar[3]
            }

        }
    }

}