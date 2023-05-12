---
marp: true
theme: gaia
_class: lead
paginate: true
backgroundColor: #fff
backgroundImage: url('res/hero-background.svg')
style: |
  section {
    padding-top: 35px;
    padding-bottom: 0px;
  } 
  ul {
    margin-top:    0px;  
    margin-bottom: 0px;
  }
  ol {
    margin-top:    0px;
    margin-bottom: 0px;
  }

---
# **RISC-V Lab**
# Ex7: Architecture(s)

---
# **Content**
1. Application specific Architectures
2. Mid Term presentation

---
# **Application specific Architectures**

## **RX / TX data from a FAST external clock**
f(clk peripheral) > 4x internal FPGA clock

Examples
* Ethernet: GMII Interface
* RGB Camera / Display
* (HDMI)
* ...

---
## **RX / TX data from a FAST external clock**
* instantiate clock buffer (BUFG)
* synchrone the reset to the new clock
* constrain clk in XDC file
* clock domain crossing: 

---
# **Mid term presentation**
* strict time limit: 6min per group + 2min for questions
  => FEW (<6) slides &  pictures & diagrams & (ultra brief texts)
* all team members must present
* aim / content
  * SELL your project
  * WHAT do you want to achieve (functional specification)
  * HOW do you plan to do it (architecture)

---
## **Mid term pres: Slide 0 - WHO**
* project name 
* list of group members

This is the only mandatory slide.
Following slides are example to give you ideas!
They can be omitted, changed etc.

---
## **Mid term presentation: Slide 1 - WHAT**
DONT: Copy bullet points from your functional spec.:
  - real time sound processing
  - 16bit @ 48kHz stereo audio in and out
  - 200k long FIR filter, latency < 5ms

DO: Create a **vision** and explain the **challenge**
  - Hall effect generator (headline)
  - **pictures** of church and organ
  - **sound / video** file
  - challenges: very long FIR filter (200k for church)
    @ short latency (5ms for organist)
    
---
## **Mid term presentation: Slide 2 - HOW**

* Hardware top level block diagram  (MOST important picture)
* (re) use it to explain
  - environment (I/O)
    e.g. diagram include speaker & mic symbols
    (if its shows nicely may additionally replace WHAT slide)
  - general data / event flow 
    e.g. add colored arrows to explain data / event flow
  - functional partitioning
    e.g. add highlight to individual module
  - ...

---
## **Mid term presentation: Slide 3..X - HOW**

* present interesting / remarkable architectural features, e.g.
  - flowchart for main algorithm e.g. ray tracing
  - networks connecting CPU arrays
  - DMA descriptors
  -  ...  
* explain major / interesting modules (architecture, functionality, register interface)

