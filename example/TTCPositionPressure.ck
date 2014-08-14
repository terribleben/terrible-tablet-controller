
// Chuck program to work in conjunction with terrible-tablet-controller.
// Plays a tone. The frequency is dependent on the stylus X position,
// and the gain is dependent on the stylus pressure.

SinOsc s => dac;
0 => s.gain;
220 => s.freq;

OscRecv recv;
4242 => recv.port;

recv.listen();

recv.event("/ttc/simple, f, f, f") @=> OscEvent oe;

while (true)
{
    oe => now;
    
    while (oe.nextMsg() != 0)
    {
        float posX, posY, pressure;
        oe.getFloat() => posX;
        oe.getFloat() => posY;
        oe.getFloat() => pressure;
        
        // TODO: use y
        220.0 * (1.0 + posX) => s.freq;
        0.4 * pressure => s.gain;
    }
}
