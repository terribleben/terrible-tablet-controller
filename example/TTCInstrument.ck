
// Chuck program to work in conjunction with terrible-tablet-controller.
// Makes a simple instrument out of your tablet.

// screen space represents numNotes notes across its width
25 => int numNotes;

// instrument voice
SinOsc s => Envelope e => dac;
0.2 => s.gain;
10::ms => e.duration;
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
            
            getNoteFrequency(posX) => s.freq;
            
            0.2 + (0.4 * pressure) => s.gain;
        }
    }
}

fun void modulateVibrato() {
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
            
            Math.sqrt(tiltY * tiltY + tiltX * tiltX) * 0.01 => vibratoAmplitude;
        }
    }
}



recv.listen();

spork ~ modulateEnvelope();
spork ~ modulateFreqGain();
spork ~ modulateVibrato();

while (8::ms => now)
{
    // compute vibrato using SHM
    vibratoMagnitude * -0.16 +=> vibratoVelocity;
    vibratoVelocity +=> vibratoMagnitude;
}
