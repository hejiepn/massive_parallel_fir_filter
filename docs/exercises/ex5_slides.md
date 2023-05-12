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
# Ex4: Interrrupts

---
# **Content**
1. System level 
2. IRQ controller
3. Peripherals
4. RISC-V Traps
5. ANSI C for IRQs

---
# **System level**
Basic Problem: (Some of the) real world act as **master** for the CPU.

* (low end) Examples
  * Audio: Fs=48kHz @ 100 MHz => ~2000 cycles / sample
  * Uart: 1 MBit @ 100 MHz => ~800 cycles / byte

Assumption: FIFO of length =1 (minimal latency)

---
## **System Level: Polling**
![bg right:40% 100%](res/ex5_irq_system_polling.drawio.svg)
* CPU efficency vs. latency
  e.g. 100 cycles per task switch 
   @ 5% of CPU cycles & 10 tasks
  => polling frequency: 20000 cycles
* even if latency is acceptable huge HW FIFOs required

=> even 0.2$ µC have IRQs
=> IRQs must for SOCs

---
## **System Level: Polling - for hard real time**
* processes realize (long) sequences as FSMs (big case)
  -> easy to determine longest path through each process
  -> no concurrent processes influence the run time
* example: Programmable Logic Control
```C
while {
   process1(...);
   process2(...);
   while (NOW() < time) {}; // burn remaining time of this cycle
   time = time + CYCLE_TIME;
}
```
---
## **System Level: IRQ driven**
![bg right:40% 100%](res/ex5_irq_system_irq.drawio.svg)

* smaller response times
  * best: CPU HW
  * worst (prio, nested): never
  * worst (non nested, single prio):
    CPU HW + longest IRQ handler
* higher CPU efficiency
  processes requiring input sleep
* IRQ types
  * vectored (address for each IRQ)  
  * prioritized
  * nested IRQs

---
## **System Level: Level IRQ protocol**

Semantic: irqN = 1 <=> periphery module N requires the CPU

When the CPU is not required any more (regardless if the initial cause has been handled with or just gone away), the periphery module de asserts its IRQ line.

---
## **System Level: Edge IRQ protocol**
Semantic: irqN rising <=> exactly now periphery N requires the CPU
Issues
* IRQs have to be cleared in the IC
  handle & clear can not be atomic: new IRQ can occur in between
  => shadow ("pending") register in IC
* periphery module can not take IRQ requests back  
* what happens with (multiple) IRQ requests during IRQs ? 
  Save or even count and execute afterwards ?
  Example: timer (clock vs. measurement)

=> IC makes decisions for the peripherals, which due to lack of information it can not always do correctly or efficiently

---
# **IRQ controller**
![bg right:50% 100%](res/ex5_irq_ctrl_wavedrom.svg)
![width:500px](res/ex5_irq_ctrl.drawio.svg)

---
## **IRQ controller: irq_no**

* irqs over all peripherals >> vectorized irqs
* accelerates SW emulation of vectored IRQs (vs. count leading 0)
```C      
// linear vs. constant effort
Interrupt_Handler() {
  if (status & irq0_mask) irq0_handler()
  if (status & irq1_mask) irq1_handler()
  ...
}

Interrupt_Handler() {
  jump ( jump_table[int_no] )
}
```

---
## **IRQ controller: all_en**
* single atomic instruction disables all irqs without side effects
* alternatives
  - CPU build in IRQ disable
  - SW interlock (e.g. via "test & set command") - overhead too large

## **IRQ controller: mask set/clr**
* allows enabling / disabling of IRQs without disabling all IRQs

---
## **IRQ controller: hierarchical**


---
# **Peripherals with IRQ**

---
## **Peripherals with IRQ**


---
# **ANSI C for IRQs**

```C
// Function pointer
void HelloWorld() { printf("Hello World\n") ; }
void (*p)();  // pointer to a function returning void

p = HelloWorld ;
(*p)();// call the function pointed to by p
p();   // same as above, abbreviation in ANSI C

// Array of array of pointers to functions returning void
void (*funarray[3])() = {c,b,c}  // pre init to c() b() c()

funarray[0] = a ;
(*funarray[0])() ; // do a();
funarray[1]() ;    // do b();
```