<Cabbage> bounds(0, 0, 0, 0)
form caption("BlackAmp-M1") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0, 1, .01), text("Master"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")


button bounds(20, 16, 80, 40) channel("pullBass") text("Pull Bass")
button bounds(108, 16, 80, 40) channel("pullTreble") text("Pull Treble")
button bounds(198, 16, 80, 40) channel("onOffLead") text("Lead On/Off")
button bounds(286, 16, 80, 40) channel("gainBoost") text("Gain Boost")

rslider bounds(226, 164, 60, 60) channel("volume") range(0, 1, 1, 1, 0.001)text("Volume") textColour(0, 0, 0, 255)
rslider bounds(152, 164, 60, 60) channel("mixLC") range(0, 1, 1, 1, 0.001)text("Lead Master") textColour(0, 0, 0, 255)
rslider bounds(84, 164, 60, 60) channel("reverbGain") range(0, 1, 0, 0.9, 0.001)text("Reverb") textColour(0, 0, 0, 255)

rslider bounds(82, 230, 60, 60) channel("bassTone") range(0, 1, 0.5, 1, 0.001)text("Bass") textColour(0, 0, 0, 255)
rslider bounds(152, 230, 60, 60) channel("midTone") range(0, 1, 0.5, 1, 0.001)text("Mid") textColour(0, 0, 0, 255)
rslider bounds(224, 230, 60, 60) channel("trebleTone") range(0, 1, 0.5, 1, 0.001)text("Treble") textColour(0, 0, 0, 255)

rslider bounds(36, 82, 60, 60) channel("80h") range(0, 1, 0, 1, 0.001)text("80Hz") textColour(0, 0, 0, 255)
rslider bounds(106, 82, 60, 60) channel("240h") range(0, 1, 0, 1, 0.001)text("240Hz") textColour(0, 0, 0, 255)
rslider bounds(176, 82, 60, 60) channel("750h") range(0, 1, 0, 1, 0.001)text("750Hz") textColour(0, 0, 0, 255)
rslider bounds(246, 82, 60, 60) channel("2200h") range(0, 1, 0, 1, 0.001)text("2200Hz") textColour(0, 0, 0, 255)
rslider bounds(314, 82, 60, 60) channel("6600h") range(0, 1, 0, 1, 0.001)text("6600Hz") textColour(0, 0, 0, 255)

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d  --opcode-lib="F:/Fork de teste do github/csoundPluginOpcodes/build/Debug/MODsK.dll"
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
ksmps = 32
nchnls = 2
0dbfs = 1


instr 1
kGain cabbageGetValue "gain"
kPullBass cabbageGetValue "pullBass"
kPullTreble cabbageGetValue "pullTreble"
kOnLead cabbageGetValue "onOffLead"
kGainBoost cabbageGetValue "gainBoost"

kGain cabbageGetValue "gain"
kVolume cabbageGetValue "volume"
kMixLC cabbageGetValue "mixLC"
kReverbGain cabbageGetValue "reverbGain"

kBassTone cabbageGetValue "bassTone"
kMidTone cabbageGetValue "midTone"
kTrebleTone cabbageGetValue "trebleTone"

k80h cabbageGetValue "80h"
k240h cabbageGetValue "240h"
k750h cabbageGetValue "750h"
k2200h cabbageGetValue "2200h"
k6600h cabbageGetValue "6600h"

/*
    //Lowpass and Highpass filtering stage
    afilt tone a1, kLowpass
    afilt atone afilt, kHighpass


    //Lowshelf and Highshelf filtering stage
    kGainLowShelf = ampdb(kGainLowShelf)
    kGainHighShelf = ampdb(kGainHighShelf)
    afilt pareq afilt, kLowshelffreq, kGainLowShelf, 0.6, 1
    afilt pareq afilt, kHighshelffreq, kGainHighShelf, 0.846, 2

    //Peak EQ stage
    kGainPeak = ampdb(kGainPeak)
    afilt pareq afilt, kFreqPeak, kGainPeak, kQ

    //Dry/Wet EQ
    aeqout ntrpol a1, afilt, kMixEQ
*/ 

;"C:/Users/kaiol/OneDrive/Cabage Projects/Guitar.mp3"

a1 diskin2 "C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/AMPs/MESA IIC+/guitar1.wav",1,0,1

a1 ntrpol a1 * ampdb(8), a1, kMixLC ;COMPENSATION THE SIGNAL LEAD TO CLEAN

;===============TONE STACK
toneStackSet 250,250,10,100,250,1e5,0.047e5
aToneS toneStack a1, kBassTone, kMidTone, kTrebleTone,1

;===============PULL BASS
if(kPullBass==1)then
    aPullBass reson a1, 287, 100,2
    aPullBass = aPullBass*ampdb(-24)
    aToneS sum aToneS, aPullBass
endif

;===============PULL BRIGTH
if(kPullTreble==1)then
    aPullTreble butbp a1, 8841.9, 300,2
    aPullTreble = aPullTreble*ampdb(12)
    aToneS1 sum aToneS, aPullTreble
else
    aToneS1 = 0
endif

aVolume = aToneS * kVolume
aVolume = aToneS1 + aVolume

;===============FILTER LOW
aFilterH tone aVolume, 4979.8

;===============LEAD DISTORCION
if (kOnLead==0)then
    aLeadOut blackAmp96 aVolume*ampdb(80),"C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/weights/MESAII_weights_without_train.json"
else
    aLeadOut = 0
endif

aOutFilterLead sum aFilterH, aLeadOut

;===============MIX CLEAN TO LEAD
aMixLeadClean ntrpol aVolume, aOutFilterLead, kMixLC

;===============REVERB
if(kReverbGain > 0)then
    aLrev,aRrev freeverb aMixLeadClean, aMixLeadClean, kReverbGain, 0.7, sr
else
    aLrev = aMixLeadClean * ampdb(-18)
endif
;===============GAIN BOOST
if(kGainBoost==1)then
    aLrev = aLrev * 2
endif

;===============EQ PARAMETRIC
;80Hz
a80h butbp aLrev, 87.61, 37.4
k80hDB ntrpol ampdb(-28),ampdb(0),k80h
a80h = a80h * k80hDB
;240Hz
a240h butbp aLrev, 371.9, 95.9
k240hDB ntrpol ampdb(-32),ampdb(0),k240h
a240h = a240h * k240hDB
;750Hz
a750h butbp aLrev, 723.4, 123.9
k750hDB ntrpol ampdb(-24),ampdb(0),k750h
a750h = a750h * k750hDB
;2200Hz
a2200h butbp aLrev, 1575.8, 1170.2
k2200hDB ntrpol ampdb(-48),ampdb(0),k2200h
a2200h = a2200h * k2200hDB
;6600Hz
a6600h butbp aLrev, 5906.7, 3617.1
k6600hDB ntrpol ampdb(-38),ampdb(0),k6600h
a6600h = a6600h * k6600hDB

aEqOut sum a80h, a240h, a750h, a2200h, a6600h
a1 sum aEqOut, aLrev

;===============IR CAB
a1 pconvolve a1 , "WHITE- CAB_dc.wav", 128

outs a1*kGain, a1*kGain
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
