// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// xbar_${xbar.name}_bind module generated by `tlgen.py` tool for assertions
module xbar_${xbar.name}_bind;

  // Host interfaces
% for node in xbar.hosts:
  bind xbar_${xbar.name} tlul_assert #(.EndpointType("Device")) tlul_assert_host_${node.name} (
    .clk_i  (${node.clocks[0]}),
    .rst_ni (${node.resets[0]}),
    .h2d    (tl_${node.name}_i),
    .d2h    (tl_${node.name}_o)
  );
% endfor

  // Device interfaces
% for node in xbar.devices:
  bind xbar_${xbar.name} tlul_assert #(.EndpointType("Host")) tlul_assert_device_${node.name} (
    .clk_i  (${node.clocks[0]}),
    .rst_ni (${node.resets[0]}),
    .h2d    (tl_${node.name}_o),
    .d2h    (tl_${node.name}_i)
  );
% endfor

endmodule
