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
# Ex9: Final Presentation
# Completing the project
---
# **Content**
1. Final presentation
2. Completing the project


---
# **Final presentation**
* strict time limit: 7min per group + 2min for questions
  => FEW (<7) slides &  pictures & diagrams & (ultra brief texts)
* all team members must present

* mid-term: vision <-> final: achievements

* aim / content
  * SELL your **ACHIEVEMENTS**
  * WHAT did you build
  * HOW did you build it
  * GREAT Results

---
## **Mid term pres: Slide 0 - WHO**
* project name 
* list of group members

Only **mandatory** slide (there is also a mandatory video).

Following slides are example to give you ideas!
They can be omitted, changed etc.

---
## **Mid term presentation: Slide 1 - WHAT**

DONT: Copy bullet points from your functional spec.

DO: Create a **vision** and explain the **challenge**
  - hall effect generator (headline)
  - **pictures** of church and organ
  - (boring) **sound / video** file *without* your design
  - **challenges**: very long FIR filter (200k for church)
    @ short latency (5ms for organist)

Note: less focus here than in the mid-terms

---
## **Mid term presentation: Slide 2..X - HOW**

* Hardware top level block diagram  (MOST important picture)
* (re) use it to explain
  - environment (I/O) 
    e.g. diagram include speaker & mic symbols
    (may replace WHAT slide)
  - architecture 
    - functional partitioning
      e.g. add highlight to individual module
    - general data / event flow 
      e.g. add colored arrows to explain data / event flow
    - ...

---
## **Mid term presentation: HOW (cnt.)**

* how you solved **hard** problems 
* interesting / remarkable architectural features, e.g.
  - flowchart for main algorithm e.g. ray tracing
  - networks connecting CPU arrays
  - DMA descriptors
  - ...  
* explain major / interesting modules (architecture, functionality, register interface)

---
## **Mid term pres.: GREAT Results - Slides**
Remarkable results not visible in the video

* performance (charts, tables...)
* pre / post pictures

---
## **Mid term pres.: GREAT Results - Video**
* **mandatory**
* most important part of the presentation !
* make it a story (with climax) by itself !
* save the best for the last act !

---
# **Completing the project**

see "Project/Tasks" page of the Sphinx documentation