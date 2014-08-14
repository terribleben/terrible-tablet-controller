
// Simple chuck program to work in conjunction with terrible-tablet-controller.
// Plays a tone as long as the stylus is touching the tablet.

SinOsc s => dac;
0 => s.gain;
220 => s.freq;

OscRecv recv;
4242 => recv.port;

recv.listen();

recv.event("/ttc/state, i") @=> OscEvent oe;

while (true)
{
    oe => now;
    
    while (oe.nextMsg() != 0)
    {
        int state;
        oe.getInt() => state;
        
        <<< "got state:", state >>>;
        
        if (state == 2)
            0.1 => s.gain;
        else
            0 => s.gain;
    }
}
