#ifndef CLK_CONFIG_H_
#define CLK_CONFIG_H_
#include <avr/io.h>
#include "FreeRTOSConfig.h"

#if (configCPU_CLOCK_HZ == 24000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL.OSCHFCTRLA | CLKCTRL_FRQSEL_24M_gc);

#elif (configCPU_CLOCK_HZ == 20000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_20M_gc);

#elif (configCPU_CLOCK_HZ == 16000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_16M_gc);

#elif (configCPU_CLOCK_HZ == 12000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_12M_gc);

#elif (configCPU_CLOCK_HZ == 10000000)

    #define CLK_init()  { \
                        _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_20M_gc);\
                        _PROTECTED_WRITE(CLKCTRL.MCLKCTRLB, CLKCTRL_PDIV_2X_gc | CLKCTRL_PEN_bm); \
                        }

#elif (configCPU_CLOCK_HZ == 8000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_8M_gc);

#elif (configCPU_CLOCK_HZ == 6000000)

    #define CLK_init()  { \
                        _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_12M_gc);\
                        _PROTECTED_WRITE(CLKCTRL.MCLKCTRLB, CLKCTRL_PDIV_2X_gc | CLKCTRL_PEN_bm); \
                        }

#elif (configCPU_CLOCK_HZ == 5000000)

    #define CLK_init()  { \
                        _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_20M_gc);\
                        _PROTECTED_WRITE(CLKCTRL.MCLKCTRLB, CLKCTRL_PDIV_4X_gc | CLKCTRL_PEN_bm); \
                        }

#elif (configCPU_CLOCK_HZ == 4000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_4M_gc);

#elif (configCPU_CLOCK_HZ == 3000000)

    #define CLK_init()  { \
                        _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_12M_gc);\
                        _PROTECTED_WRITE(CLKCTRL.MCLKCTRLB, CLKCTRL_PDIV_4X_gc | CLKCTRL_PEN_bm); \
                        }

#elif (configCPU_CLOCK_HZ == 2000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_2M_gc);

#elif (configCPU_CLOCK_HZ == 1000000)

    #define CLK_init()  _PROTECTED_WRITE(CLKCTRL.OSCHFCTRLA, CLKCTRL_FRQSEL_1M_gc);

#else

    #error The selected clock frequency is not supported. Choose a value from the NOTE in FreeRTOSConfig.h.

#endif

#endif /* CLK_CONFIG_H_ */