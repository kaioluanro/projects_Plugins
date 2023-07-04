<Cabbage>
form caption("SVG Volume Control") size(400, 400), guiMode("queue") pluginId("def1")
image bounds(0, 0, 400, 400) channel("background")

rslider bounds(200, 200, 100, 100) channel("volume"), range(0, 1, 0.5), alpha(0), trackerColour(0, 0, 0, 0), toFront("1")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -+rtmidi=NULL -M0 -m0d
</CsOptions>
<CsInstruments>
; Initialize the global variables.
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
    ; Captura o sinal de entrada
    ain     inch    2

    ; Configuração para análise de frequência
    isize   =       1024
    ioverlap =      isize / 4
    iwinsize =      isize
    iwin    =       1
    ifft    =       1

    ; Análise de frequência
    fenv    pvsanal ain, isize, ioverlap, iwinsize, iwin, ifft

    ; Estima o pitch
    kFreq, kConf   pvspitch fenv,1

    ; Calcula a nota MIDI e a oitava
    kMidi   cpsmidinn   kFreq
    kNote   =          round(kMidi) - 12 * round(kMidi / 12)
    kOctave =          round(kMidi / 12) - 1
    
    printks "Nota: %f%f\\n", 1, kNote, kFreq
    ; Exibe a nota e a oitava
    kTrig   changed    kNote, kOctave
    if (kTrig == 1 && kConf > 0.7) then
      
    endif
    outs ain, ain
  endin
</CsInstruments>
<CsScore>

; run indefinitely
f 0 z
; start instruments 1 and 2
i1 0 [60*60*24*7] 
;i 2 0 z
</CsScore>
</CsoundSynthesizer>
