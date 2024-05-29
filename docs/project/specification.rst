Requirements & Functional Specification
=======================================

Requirements Specification
--------------------------

**Executive summary of customer requirements ("Lastenheft", "Pflichtenheft")**

* summary what is to be done
* "business drivers" (overarching objective)
* operation environment & constraints

As *short* as possible. In most cases *1-3 sentences* are sufficient.

Example "Pacman": Aim of the project is the implementation of the video game "Pacman" for exhibition at TUB pupils' day to advocate SoC design.

**Executive summary of customer requirements ("Lastenheft", "Pflichtenheft")**

* Project: FPGA IN MUSIC AND AUDIO PROCESSING
* Content: Aim of the project is the implementation of different audio processing techniques to manipulate the output audio to the chosen mode based on the input audio.

Functional Specification
------------------------

**"WHAT is build." Your answer to the customer's requirements. Basis for contract.**

*Precise, detailed* description of the functionality of the design from the *user's / customer's perspective*. Use bullet points, add drawings if applicable.  Do not list implementation details: e.g. "artifact free frame update rate @ 50Hz" not "uses double buffering and dual ported block rams to achieve ...".

Example "Pacman":

* description of the game mechanics (task, player's character, opponents, game area,  modes (single / multy player), levels, ...
* detailed game parameters (e.g. size in pixels of characters, ...)
* display: type (HDMI, LCD, ..), resolution, colors, refresh rate
* sound: PCM (# channels, sample rate, resolution, ...) ?
* user input interface: joystick
* performance requirements: e.g. maximal game loop cycle time
* ...

    .. note::
        Specify as mandatory only a minimal viable project. List stretch goals in an "optional" section.
