<Cabbage>
form caption("Ablento Test") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(296, 162, 100, 100), channel("gain"), range(0, 1, 0.3, 1, .01), text("Gain"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")

rslider bounds(168, 162, 100, 100), channel("treble"), range(0, 1, 0.5, 1, 0.01), text("Treble"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)
rslider bounds(068, 162, 100, 100), channel("mid"), range(0, 1, 0.5, 1, 0.01), text("Mid"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)
rslider bounds(068, 062, 100, 100), channel("bass"), range(0, 1, 0.5, 1, 0.01), text("Bass"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)


</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d --opcode-dir=";C:/Users/kaiol/OneDrive/Cabbage MODsK"
</CsOptions>
<CsInstruments>
; Initialize the global variables. 
;ksmps = 128
nchnls = 2
0dbfs = 1


instr 1
kGain cabbageGetValue "gain"
kTreble cabbageGetValue "treble"
kMid cabbageGetValue "mid"
kBass cabbageGetValue "bass"

a1 diskin2 "C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/AMPs/MESA IIC+/guitar2.wav",1,0,1
;a1 inch 1

aToneS toneStack a1, kBass, kMid,kTreble,0,2

outs aToneS*kGain, aToneS*kGain
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z
;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
