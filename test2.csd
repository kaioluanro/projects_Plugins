<Cabbage>
form caption("Untitled") size(400, 300), guiMode("queue") pluginId("def1")

rslider bounds(296, 162, 100, 100), channel("Master"), range(0, 1, 0.2, 1, .01), text("Master"), trackerColour("lime"), outlineColour(0, 0, 0, 50), textColour("black")
rslider bounds(160, 162, 100, 100), channel("tone"), range(0, 1, 0.5, 1, 0.01), text("Tone"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)
rslider bounds(60, 162, 100, 100), channel("dist"), range(0, 1, 0.5, 1, 0.01), text("Distorcion"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)

rslider bounds(60, 62, 100, 100), channel("Gain"), range(0, 1, 0.5, 1, 0.01), text("Gain"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)

rslider bounds(196, 50, 60, 60) channel("bass") range(0, 1, 0.5, 1, 0.001) text("bass")
rslider bounds(266, 52, 60, 60) channel("mid") range(0, 1, 0.5, 1, 0.001) text("mid")
rslider bounds(334, 52, 60, 60) channel("treble") range(0, 1, 0.5, 1, 0.001) text("treble")

</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d -odac --opcode-dir=";F:/Fork de teste do github/MODsK/MODsK/x64/Release/"
</CsOptions>
<CsInstruments>
; Initialize the global variables.
ksmps = 128
nchnls = 2
0dbfs = 1

giIR_record 	ftgen	0, 0, 131072, 2, 0

instr 13

p3 		=	ftlen(giIR_record)/sr
iskip 	=	p4
irlen 	=	p5
a1 		diskin2	"I:/IRs/Fender_Twin_73_IR_Pack/03_Twin73_center_L19.wav", 1, iskip

; Fill IR table with segment from audio file
amp 	linseg	0, 0.001, 1, irlen, 1, 0.3, 0, 1, 0
andx_IR line	0, 1, 1/(ftlen(giIR_record)/sr)
		tablew	a1*amp, andx_IR, giIR_record, 1
		outch	1, a1*amp	; output the IR
		
ktrig 	init	1
if ktrig > -1 then
	chnset	ktrig, "conv_update"
	ktrig -= 1
endif


endin

instr 1

a1 diskin2 "C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/AMPs/MESA IIC+/guitar1.wav",1,0,1
;a1 inch 2

kMaster cabbageGetValue "Master"
kTone  cabbageGetValue "tone"
kDist cabbageGetValue "dist"
kGain cabbageGetValue "Gain"

kBassEQ  cabbageGetValue "bass"
kMidEQ cabbageGetValue "mid"
kTrebleEQ cabbageGetValue "treble"

;========================= DISTORTION LEVEL
kBlackAmpGain ntrpol 1, 16, kGain

aSat blackAmp a1*ampdb(kBlackAmpGain),"C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/weights/B59BM.json"
;aSat blackAmp96 a1*ampdb(50),"C:/Users/kaiol/OneDrive/Estudos de Deep Learning/Black-Box model LSMT/weights/OVERDRIVER_model4.json"

;========================= MIX CLEAN | DIST
a1 ntrpol a1, aSat, kGain

aToneS toneStack a1, kBassEQ, kMidEQ, kTrebleEQ,0,1

;aSat WDF a1, kDist, kTone,ksatGain
/*

a1 ntrpol a1, aSat, kDist


;========================= TONE
;A1
aBdRj butbr a1, 1000, 2000
aHighBdrj atone aBdRj,100

aFilterLow tone a1 , 723
aFilterBpTreble reson aFilterLow, 1000, 8000, 1
aFilterBpBass reson aFilterLow, 10, 600, 1

aTone ntrpol aFilterBpBass, aFilterLow, kTone

a1 sum aTone, aBdRj*ampdb(-42)


;========================= OUT
*/
a1 pconvolve aToneS , "I:/IRs/York.Audio.BMAN.410.P10Q/48k (Fractal, Line 6, Suhr, Atomic, etc.)/Natural Phase Singles/YA BMAN 410 P10Q 121-1.wav",128

;kupdate chnget	"conv_update"
;aconv liveconv aToneS, giIR_record, 128, kupdate, 0


;a1 ntrpol aconv*ampdb(12), aSat, 0.0
;printk 1,k(aSat)
;CheckUseSystem
;aout vco2 0.5, 440
a1 = a1*ampdb(8)

outs a1*kMaster, a1*kMaster
endin

</CsInstruments>
<CsScore>
;causes Csound to run for about 7000 years...
f0 z

i13	0 1 0.0 120000

;starts instrument 1 and runs it for a week
i1 0 [60*60*24*7] 
</CsScore>
</CsoundSynthesizer>
