#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=elf
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=-mafrlcsj
else
COMPARISON_BUILD=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/83377035/USART.o.d ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d ${OBJECTDIR}/_ext/1347852338/port.o.d ${OBJECTDIR}/_ext/1644529106/event_groups.o.d ${OBJECTDIR}/_ext/1644529106/heap_1.o.d ${OBJECTDIR}/_ext/1644529106/list.o.d ${OBJECTDIR}/_ext/1644529106/queue.o.d ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d ${OBJECTDIR}/_ext/1644529106/tasks.o.d ${OBJECTDIR}/_ext/1644529106/timers.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/main.o

# Source Files
SOURCEFILES=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c main.c



CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/main.o: main.c  nbproject/Makefile-${CND_CONF}.mk 
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: assembleWithPreprocess
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
else
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex"
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r ${OBJECTDIR}
	${RM} -r ${DISTDIR}

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(wildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
