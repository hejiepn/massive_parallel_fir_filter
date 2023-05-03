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
# Ex3: On Chip Interconnects

---
# **Content**
1. Basics
2. Transaction based
3. Packet Based / NoC
4. Topologies
5. Implementation
6. Examples

---
# **Basics**
* purpose: *exchange data* between N on chip components.
* **common logical model** of all components: hardware resources (registers, memory) mapped into "flat" address space
* primarily standardized **interface**, not topology
* maximizes **reuse** ("lego") of
  * know how
  * modules
  * test, debugging & profiling infrastructure

---
## **Basics: Nodes**
Classes of nodes
* master / host: initiates transfer
* slave / device: determines speed of transfer

![bg right:50% 100%](res/ex4_buswait_wavedrom.svg)

Slave can stop a transfer anytime (ready, ack ...)
=> master / bus blocked
=> loss of throughput (& latency)

---
**Approaches to prevent a blockade of the master & interconnect**

1. Master provides additional information to the slave
   e.g. which addresses will be next, such as "burst" access

2. Split transfer
Master releases bus for new transfers during the wait period and the transfer is resumed later (often not feasible / too complex)

3. Pipelining

4. Decouple request from action (read/write)   
   -> message based NoC (different concept)

5. multi master & "multi layer" interconnect (switch, crossbar) 

---
# **Pipelining**
![bg vertical right:50% 70%](res/ex4_0ps_wavedrom.svg)
![bg vertical right:50% 90%](res/ex4_1ps_wavedrom.svg)
![bg vertical right:50% 90%](res/ex4_2ps_wavedrom.svg)

* 0 pipeline stages
  - one transfer in flight
  - combinational loop
    master -> slave -> master 
    (adr/ctrl -> "ready" / data (read)

* 1 pipeline stage
  - two transfers in flight

* 2 pipeline stages

---
# **Decouple**


---
# **Topologies: Basics**

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
## **Topologies: Hierarchical**
* many intermediates (cube,...) topologies
  * sparse crossbar: 1:N, M:1 
  * ...
* common: hierarchical structures build from (sparse) crossbars

---
## **Toplogies: Examples**
![width:420px](../design_ref/rvlab_core.svg)
![bg right:50% 86%](res/ex4_stm32f745ig.png)

---
# **Multi Master**