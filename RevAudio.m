clc;
clear;

choice = input('Enter 1 to select an audio file, 2 to record audio: ');

if choice == 1
    % Select file
    [fileName1, filePath1] = uigetfile({'*.mp3','mp3 Format (*.mp3)'},'Select the Audio File');
    audioFilePath1 = fullfile(filePath1, fileName1);
     [audioData1, sampleRate1] = audioread(audioFilePath1);
elseif choice == 2
    % To record your audio
    duration = input('Enter recording duration in seconds: ');
    
    Voice = audiorecorder(44100, 16, 1); 
    disp('Start speaking.');
    recordblocking(Voice, duration);
    disp('End of recording.');
    
    
    audioData1 = getaudiodata(Voice);
    sampleRate1 = Voice.SampleRate;
else
    error('Invalid choice. Please enter 1 or 2.');
end


% input reverb time
reverbTime = input('Enter reverb time in seconds:(the value should be lesser than 1 and greater tahn 0) ');

reverbedAudio = reverberator('PreDelay', 0.05, 'WetDryMix', 0.5, 'DecayFactor', reverbTime);
audioDataReverbed = reverbedAudio(audioData1);

timeOriginal = ((0:length(audioData1)-1) * (1/sampleRate1));
timeReverbed = ((0:length(audioDataReverbed)-1) * (1/sampleRate1));

subplot(2, 1, 1);
plot(timeOriginal, audioData1);
title('Original Audio Waveform');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2, 1, 2);
plot(timeReverbed, audioDataReverbed);
title('Reverbed Audio Waveform');
xlabel('Time (s)');
ylabel('Amplitude');

[outputFileName, outputFilePath] = uiputfile({'*.wav', 'Waveform Audio File Format (*.wav)'; '*.mp3', 'MPEG Audio Layer III (*.mp3)'}, 'Save As', 'output_audio_reverbed.wav');

if isequal(outputFileName, 0) || isequal(outputFilePath, 0)
    disp('User canceled the operation');
else
   
    outputFile = fullfile(outputFilePath, outputFileName);
    
   %save
    audiowrite(outputFile, audioDataReverbed, sampleRate1);
    disp(['Reverbed audio file saved to: ' outputFile]);
end


