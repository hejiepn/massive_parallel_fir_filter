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
# Ex3: On chip Interconnects

---
# **Content**
1. Basics
2. Classical
3. Packet Based / NoC
4. RTL Implementation
5. Examples

---
# **Basics**
* purpose: *exchange data* between N on chip components.
* *common* logical model of all components: hardware resources (registers, memory) mapped into **"flat" address space**
* Standardized interface:
  Primary module **interface**, not topology

---
## **Topologies: Basics**

<style scoped>
table {
    height: 25%;
    width: 80%;
    font-size: 25px;
}
th {
}
</style>

Topology           | connections  | simultaneous| comment
-------------------|--------------|-------------|-------------
(shared) bus       |  M:N, 1:N    | 1           | e.g. (legacy) PCB
crossbar / switch  |    M:N       | M           | completely connected
point 2 point      |    1:1       | 1           | 

![width:900px](res/ex4_topologies.svg)

---
## **Topologies: Hierachical**
* many intermediates (cube,...)
  * sparse crossbar: 1:N, M:1 
* common: hierachical structures build with (sparse) crossbar:

---
## **Toplogies: Examples**
![width:420px](../design_ref/rvlab_core.svg)
![bg right:50% 86%](res/ex4_stm32f745ig.png)

---
## **Basics: classes of interconnect nodes**
* master / host: initiates transfer
* slave / device: determines speed of transfer


Hold of an transfer
Slave can stop a transfer until it has processed it (ready, nwait ....)
 => Master / bus blocked
 => (Subsequent) transfers would be executed N-times
 => "Strobe" signal or handshake required (not: compare addresses...)