
// Chuck program to work in conjunction with terrible-tablet-controller.
// Makes a simple instrument out of your tablet.
// 
// touch => note on
// X => instrument pitch
// Y => filter frequency
// tilt => vibrato and harmonic
// pressure => gain

// screen space represents numNotes notes across its width
25 => int numNotes;

// instrument voices
SqrOsc fundamental => Gain g => Envelope e => BPF f => dac;
SqrOsc harmonic => g;

1 => fundamental.gain;
0 => harmonic.gain;
0.2 => g.gain;
10::ms => e.duration;
0.04 => f.Q;
500 => f.freq;

1 => float vibratoMagnitude;
0 => float vibratoVelocity;
0 => float vibratoAmplitude;

// OSC listener
OscRecv recv;
4242 => recv.port;

fun int getBluesScale(int chromatic)
{
    [ 0, 3, 5, 6, 7, 10 ] @=> int scaleDegrees[];
    Math.floor(chromatic / scaleDegrees.cap()) $ int => int baseOctave;
    chromatic - (baseOctave * scaleDegrees.cap()) => int offset;
    
    return (baseOctave * 12) + scaleDegrees[offset];
}

fun float getNoteFrequency(float xPosition)
{
    55 => float anchorFreq; // low A
    getBluesScale(Math.floor(xPosition * numNotes) $ int) => int noteIdx;
    anchorFreq * Math.pow(2.0, (noteIdx / 12.0)) => float freq;
    return freq * (1.0 + (vibratoMagnitude * vibratoAmplitude));
}

fun void modulateEnvelope() {
    recv.event("/ttc/state, i") @=> OscEvent evState;
    
    while (true)
    {
        evState => now;
        
        while (evState.nextMsg() != 0)
        {
            int state;
            evState.getInt() => state;
            
            if (state == 2)
                e.keyOn();
            else
                e.keyOff();
        }
    }
}

fun void modulateFreqGain() {
    recv.event("/ttc/mouse, f, f, f") @=> OscEvent evMouse;
    
    while (true)
    {
        evMouse => now;
        
        while (evMouse.nextMsg() != 0)
        {
            float posX, posY, pressure;
            evMouse.getFloat() => posX;
            evMouse.getFloat() => posY;
            evMouse.getFloat() => pressure;
            
            10 + (490 * posY) => f.freq;
            
            getNoteFrequency(posX) => fundamental.freq;
            fundamental.freq() * 3.0 => harmonic.freq;
            
            0.2 + (0.4 * pressure) => g.gain;
        }
    }
}

fun void modulateVibratoHarmonic() {
    recv.event("/ttc/tablet, f, f, f") @=> OscEvent evTablet;
    
    while (true)
    {
        evTablet => now;
        
        while (evTablet.nextMsg() != 0)
        {
            float tiltX, tiltY, rotationDegrees;
            evTablet.getFloat() => tiltX;
            evTablet.getFloat() => tiltY;
            evTablet.getFloat() => rotationDegrees;
            
            Math.sqrt(tiltY * tiltY + tiltX * tiltX) => float tiltMagnitude;
            tiltMagnitude * 0.01 => vibratoAmplitude;
            1.0 - tiltMagnitude => fundamental.gain;
            tiltMagnitude * 0.8 => harmonic.gain;
        }
    }
}



recv.listen();

spork ~ modulateEnvelope();
spork ~ modulateFreqGain();
spork ~ modulateVibratoHarmonic();

while (8::ms => now)
{
    // compute vibrato using SHM
    vibratoMagnitude * -0.16 +=> vibratoVelocity;
    vibratoVelocity +=> vibratoMagnitude;
}
