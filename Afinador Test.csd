<Cabbage> bounds(0, 0, 0, 0)
form caption("Afinador Test") size(400, 300), guiMode("queue") pluginId("def1")
rslider bounds(294, 200, 100, 100), channel("gain"), range(0, 1, 0.4, 1, 0.01), text("Gain"), trackerColour(0, 255, 0, 255), outlineColour(0, 0, 0, 50), textColour(0, 0, 0, 255)

button bounds(174, 80, 46, 72) channel("buttonTunerOpen") text(" ", " ") imgFile("On", "Pictures\Renders\B59\iconTuner.png") imgFile("Off", "Pictures\Renders\B59\iconTuner.png")

groupbox bounds(2, 14, 393, 182) channel("gbTuner") visible(0) plant {
    label bounds(66, 34, 270, 57) channel("NoteLabel")
    label bounds(146, 142, 114, 22) channel("HzLabel")
    hslider bounds(42, 88, 314, 53) channel("hslider10002") range(-50, 50, 3.12401, 1, 0.001)
    label bounds(352, 108, 37, 16) channel("label10005") text("+50")
    label bounds(10, 108, 37, 16) channel("label10005") text("-50")
    button bounds(340, 18, 50, 39) channel("buttonTunerClose") text("X")
}

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

;Função auxiliar para Afinação de instrumento temperado
opcode tunerTemperament, SSkk , a
    a1 xin
    SNoteFullInfo init ""
    kgetPch init 27
    kNoteIndex init 0
    kCents init 0
    iRefFreqInHz init 440
    kIdx init 0  
    ; Calcula a afinação usando pitchamdf
    kPitch, kConfidence pitchamdf a1, 60, iRefFreqInHz,iRefFreqInHz
    
    ; Array com os nomes das notas e array com Frequency com 88 notas 
    kNote_freqs [] fillarray 27.50, 29.14, 30.87, 32.70, 34.65, 36.71, 38.89, 41.20, 43.65, 46.25, 49.00, 51.91, 55.00, 58.27, 61.74, 65.41, 69.30, 73.42, 77.78, 82.41, 87.31, 92.50, 98.00, 103.83, 110.00, 116.54, 123.47, 130.81, 138.59, 146.83, 155.56, 164.81, 174.61, 185.00, 196.00, 207.65, 220.00, 233.08, 246.94, 261.63, 277.18, 293.66, 311.13, 329.63, 349.23, 369.99, 392.00, 415.30, 440.00, 466.16, 493.88, 523.25, 554.37, 587.33, 622.25, 659.26, 698.46, 739.99, 783.99, 830.61, 880.00, 932.33, 987.77, 1046.50, 1108.73, 1174.66, 1244.51, 1318.51, 1396.91, 1479.98, 1567.98, 1661.22,1760.00, 1864.66, 1975.53, 2093.00, 2217.46, 2349.32, 2489.02, 2637.02, 2793.83, 2959.96, 3135.96, 3322.44, 3520.00, 3729.31, 3951.07, 4186.01, 4434.92, 4698.64, 4978.03, 5274.04, 5587.65, 5919.91, 6271.93, 6644.88, 7040.00, 7458.62, 7902.13, 8372.02, 8869.84, 9397.27, 9956.06, 10548.08, 11175.30, 11839.82, 12543.85, 13289.75, 14080.00, 14917.24, 15804.27, 16744.04, 17739.69, 18794.55, 19912.13, 21096.16, 22350.61, 23679.64, 25087.71, 26579.50, 28160.00, 29834.48, 31608.53, 33488.07, 35479.39, 37589.09, 39824.26, 42192.33, 44701.23, 47359.28, 50175.72, 53158.58, 56320.00, 59668.97, 63217.06, 66976.14, 70958.77, 75178.19, 79648.51, 84384.66, 89402.46, 94718.56, 100351.41, 106317.17, 112640.00, 119337.94, 126434.12, 133952.29, 141916.49, 150356.37, 159297.03, 168769.32, 178805.91, 189437.13, 200702.81, 212634.35, 225280.00, 238675.89, 252868.25, 267904.58, 283832.97, 300712.74, 318594.06, 337538.64, 357611.83, 378874.25, 401405.63, 425268.70, 450561.24, 477351.78, 505737.51, 535809.15, 567665.94, 601425.48, 637189.31, 675077.28, 715223.66, 757748.49, 802811.26, 850537.40, 901122.48, 954703.56, 1011475.01, 1071619.01, 1135331.88, 1202850.96, 1274378.62, 1350154.56, 1430447.33, 1515496.98, 1605622.52, 1701074.80, 1802244.96, 1909407.11, 2022950.01, 2143238.03, 2270663.76, 2405701.92, 2548757.24, 2700309.12, 2860894.66, 3030993.96, 3211245.04, 3402149.60, 3604489.92, 3818814.22, 4045900.02, 4286476.06, 4541327.53, 4811403.85, 5097514.48, 5400618.23, 5721789.32, 6061987.91, 6422491.68, 6804299.20, 7208978.42, 7637628.44, 8091800.04, 8572952.11, 9082655.06, 9622807.70, 10195029.00, 10765028.95,11351223.63, 11959975.82

    SnotesNames [] fillarray "A0", "A#0/Bb0", "B0", "C1", "C#1/Db1", "D1", "D#1/Eb1", "E1", "F1", "F#1/Gb1", "G1", "G#1/Ab1", "A1", "A#1/Bb1", "B1", "C2", "C#2/Db2", "D2", "D#2/Eb2", "E2", "F2", "F#2/Gb2", "G2", "G#2/Ab2", "A2", "A#2/Bb2", "B2", "C3", "C#3/Db3", "D3", "D#3/Eb3", "E3", "F3", "F#3/Gb3", "G3", "G#3/Ab3", "A3", "A#3/Bb3", "B3", "C4", "C#4/Db4", "D4", "D#4/Eb4", "E4", "F4", "F#4/Gb4", "G4", "G#4/Ab4", "A4", "A#4/Bb4", "B4", "C5", "C#5/Db5", "D5", "D#5/Eb5", "E5", "F5", "F#5/Gb5", "G5", "G#5/Ab5", "A5", "A#5/Bb5", "B5", "C6", "C#6/Db6", "D6", "D#6/Eb6", "E6", "F6", "F#6/Gb6", "G6", "G#6/Ab6", "A6", "A#6/Bb6", "B6", "C7", "C#7/Db7", "D7", "D#7/Eb7", "E7", "F7", "F#7/Gb7", "G7", "G#7/Ab7", "A7", "A#7/Bb7", "B7", "C8"

    ; Cálculo do índice da array com base na frequência em Hz
    kgetPch =round(kPitch)
    
    ; Calcula a Cents
    kMinDiff = abs(kNote_freqs[0] - int(kgetPch))
    kMinIndex = 0
    kIdx = 1

    while kIdx < lenarray(kNote_freqs) do
      kDiff = abs(kNote_freqs[kIdx] - int(kgetPch))

      if kDiff < kMinDiff then
        kMinDiff = kDiff
        kMinIndex = kIdx
      endif

      kIdx += 1
    od
    
    kCents1 = 1200 * log2(kNote_freqs[kMinIndex] / kPitch)
    kCents wrap kCents1, -50, 50
    
    kNoteIndex=kMinIndex
    
    ; Juntas os dados obtidos em uma String com todas Infomacoes
    SNoteFullInfo sprintfk "%s %+3.2f cents", SnotesNames[kNoteIndex], kCents
    
    ; Retorna o nome da nota, oitava e cents
    xout SNoteFullInfo,SnotesNames[kNoteIndex], kCents, kPitch
endop

instr 1
kGain cabbageGetValue "gain"

;Controle a interface
kgbTunerVisible cabbageGet "gbTuner","visible"
kTrigb changed chnget:k("buttonTunerOpen")
kTrigb2 changed chnget:k("buttonTunerClose")
cabbageSet kTrigb,"gbTuner", "visible", kgbTunerVisible==1 ? 0 : 1
cabbageSet kTrigb2,"gbTuner", "visible", kgbTunerVisible==1 ? 0 : 1

a1 inch 2

;Funçao afinador
SNoteFullInfo,SNoteNameUnique,kCents, kFreqHz tunerTemperament a1*1.2

;Coloque Informa do Afinador na Interface
cabbageSetValue "hslider10002", -kCents

kTriggNoteName metro .5,.5
cabbageSet kTriggNoteName,"NoteLabel", "text", SNoteNameUnique
ShzNote sprintfk "%6.2f Hz", kFreqHz
cabbageSet kTriggNoteName,"HzLabel", "text", ShzNote

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
