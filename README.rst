RISC-V Lab
==========

Run ``make html`` in the *docs/* directory to generate HTML documentation.

If you run the project outside of the MSC network follow *docs/tutorials/setup/index.rst* to install the required software.

This is a System Verilog version of a massive parallel FIR Filter.


Current Issues:
  It has some noise coming out, and his impulse response does not go to zero.
  If you got to fix it, I would be happy to know about it :D


The latest version can be found on the branch: NewStartStereo

# Massive Parallel FIR Filter

## Overview

This project implements a **high-performance Finite Impulse Response (FIR) filter** designed for massively parallel execution.

The goal is to optimize digital signal processing (DSP) workloads using parallel computation techniques to achieve high throughput and efficient CPU utilization.

---

## What This Project Is

A FIR filter is a core DSP component used to process signals by applying a weighted sum over a sliding window.

This implementation focuses on:

- Parallelizing filter computations
- Optimizing performance for large-scale input signals
- Efficient memory and cache usage

---

## What I Implemented

- FIR filter kernel implementation from scratch
- Parallel processing pipeline for large signal arrays
- Efficient convolution-based computation model
- Thread-level or task-level parallelization (depending on build)
- Optimized memory access patterns for cache performance
- Configurable filter coefficients (taps)

---
