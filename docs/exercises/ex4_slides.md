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
2. Pipelining
3. Decouple
4. Topologies
5. Multi Master
6. Implementation
7. Examples

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
# **Prevent blockade of master & interconnect**

1. Master provides additional information to the slave
   e.g. which addresses will be next, such as "burst" access

2. Split transfer
Master releases bus for new transfers during the wait period and the transfer is resumed later (often not feasible / too complex)

3. Pipelining

4. Decouple request from action (read/write)   
   -> message based NoC)

---
## **Pipelining**
![bg vertical right:50% 100%](res/ex4_0ps_wavedrom.svg)
![bg vertical right:50% 100%](res/ex4_0ps_rtl.svg)

**0 pipeline stages**
  - 0..1 transfers in flight
  - combinational loop
    master -> slave -> master 
    (adr/ctrl -> "ready" / data (read)

---
## **Pipelining**
![bg vertical right:50% 90%](res/ex4_1ps_wavedrom.svg)
![bg vertical right:50% 90%](res/ex4_1ps_rtl.svg)
![bg vertical right:50% 90%](res/ex4_1ps0ps_rtl.svg)

**1 pipeline stage**
  - 0..2 transfers in flight
  - hold by slaves hols the *next* transfer

**1 read / 0 write pipeline stages**
  - used by SPSRAM

---

### **Pipelining: Conversion 1r/0w -> 1r/1w**

---
## **Pipelining: 2 stages**
* becomes very complex (es. crossbars)
* may be too long / short, depending on slave

=> need "variable" pipeline depth

![bg vertical right:50% 90%](res/ex4_2ps_wavedrom.svg)

---
## **Decouple**
**decouple action (read/write) from bus transaction**
* "bus read/write" = request message + response message
* independent channels for request & response
* handshaking for messages, not action


=> bus latencies do not impact throughput
=> 0..∞ simultaneous transactions

Examples
* ARM AMBA **AXI** (Advanced eXtensible Interface)
* Tile Link

---
## **Decouple: TL-UL: a channel**
![width:900px](res/ex4_tlul_a_wavedrom.svg)

---
## **Decouple: TL-UL: d channel**
![width:900px](res/ex4_tlul_d_wavedrom.svg)

---
# **Topologies: Extremes**

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
(shared) bus       |  M:S, 1:S    | 1           | e.g. (legacy) PCB
crossbar / switch  |    M:S       | min(M,S)    | completely connected
point 2 point      |    1:1       | 1           | 

![width:900px](res/ex4_topologies.svg)

---
## **Topologies: Hierarchical**
* many intermediates topologies: ring, cube  , ...
* hierarchical structures using (sparse) crossbars
  * sparse = subset of (M,S)
  * extremes: 1:N, M:1 

---
## **Toplogies: Examples**
![width:420px](../design_ref/rvlab_core.svg)
![bg right:50% 86%](res/ex4_stm32f745ig.png)

---
# **Single Master**
![bg right:50% 98%](res/ex4_single_master.svg)

1. PERI -> CPU
2. /3. (CPU <-> RAM)
4. CPU -> PERI

* **every** word moved by the CPU at least twice
* interconnect latency to peri directly slows down  CPU

Ex.: SPI without DMA handled by 400 MHz R7 ARM in an SoC ⇒<20 Mbit  

---
# **Multi Master**
![bg right:50% 90%](res/ex4_multi_master.svg)
1. peri -> RAM
2. CPU switches pointers
3. RAM -> peri

* peri works on (complex) data structures (e.g.  descriptors, linked lists, instructions)
* CPU works in parallel
* interconnect latency to peri hidden from CPU  

---
