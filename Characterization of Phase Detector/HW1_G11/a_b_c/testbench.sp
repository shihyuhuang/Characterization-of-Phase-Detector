# test

.prot 
.lib "cic018.l" TT
.unprot
.option post

.include "./spi/DFF.spi"
*.include "./spi/sa.spi"
*.include "./spi/PD3.spi"

.param tu = 1p

X1 clk in out vdd GND DFF
*X2 in clk down up vdd gnd sa
*X3 VDD in clk VDD out vdd GND PD3

VCLK CLK 0 PULSE(0 1.8	("200*tu")	("tu*0.001")	("tu*0.001")	("499.999*tu")	("1000*tu"))
Vtarg in 0 PULSE(0 1.8	("215*tu")	("tu*0.001")	("tu*0.001")	("499.449*tu")	("999*tu"))
VVDD VDD 0 1.8

.trans ("tu/10000") ("70000*tu")

.end	





