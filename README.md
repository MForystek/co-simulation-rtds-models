# Power System and Network co-simulation

Power system models for co-simulation framework implemented for RTDS using RSCAD.

Main model `LFC with network` implements the IEEE 39-bus system with interface for network communication with the co-simulation network emulation.

`DNP3 poc` and `Modbus poc` present proof of concept implementation for the simple attack scenario with network communication via DNP3 and Modbus protocols respectively.

`Kundur Two Area Power System` and `IEEE 9-bus Power System` implement Dynamic Load Altering Attacks for two additional power system models.

The network emulation is available at https://github.com/MForystek/co-simulation-network-emulation.

## How to use

1. Open the selected sytem model using RSCAD
2. Adjust network parameters for DNP3 or Modbus network components to match your RTDS setup
3. Run the simulation through RSCAD while the network emulation is also running
