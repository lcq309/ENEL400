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
FINAL_IMAGE=${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../Drivers/ADC.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c ../../ModularTasks/Communications/XBEETASKS.c main.c DSIO.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/83377035/ADC.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o ${OBJECTDIR}/main.o ${OBJECTDIR}/DSIO.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/83377035/USART.o.d ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d ${OBJECTDIR}/_ext/83377035/ADC.o.d ${OBJECTDIR}/_ext/1347852338/port.o.d ${OBJECTDIR}/_ext/1644529106/event_groups.o.d ${OBJECTDIR}/_ext/1644529106/heap_1.o.d ${OBJECTDIR}/_ext/1644529106/list.o.d ${OBJECTDIR}/_ext/1644529106/queue.o.d ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d ${OBJECTDIR}/_ext/1644529106/tasks.o.d ${OBJECTDIR}/_ext/1644529106/timers.o.d ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/DSIO.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/83377035/ADC.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o ${OBJECTDIR}/main.o ${OBJECTDIR}/DSIO.o

# Source Files
SOURCEFILES=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../Drivers/ADC.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c ../../ModularTasks/Communications/XBEETASKS.c main.c DSIO.c



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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/57b98851af20344b9cdaedf1a44d06276306a008 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/87540ccfef88f5c4adfc79b8cffa80ac1181d33c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/83377035/ADC.o: ../../Drivers/ADC.c  .generated_files/flags/default/f06239383c7f8916abb1bbcc513c7fd4e809599e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ADC.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ADC.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ADC.o.d" -MT "${OBJECTDIR}/_ext/83377035/ADC.o.d" -MT ${OBJECTDIR}/_ext/83377035/ADC.o -o ${OBJECTDIR}/_ext/83377035/ADC.o ../../Drivers/ADC.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/c7dc36e8ed8621821316738b976175287b108a78 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/86ea86a99c31e11ceaff103321ac0ba65d738c05 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/baa188f4630549cf00c453beb103d6207f9bf1d9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/245e3ad04e154861bbc7cda8c94ac17a25234a17 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/bc967c929e539673641c4c5166cde26e90a168ac .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/47350e7a8e09483fd8ba9d375cb7d05281b629f2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/6ef969d6f5a9964f2d4ba923b2eafa171b7015b0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/4937542d42c8832aa80c08280f847aa991c6c894 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/_ext/2083278984/XBEETASKS.o: ../../ModularTasks/Communications/XBEETASKS.c  .generated_files/flags/default/f2f336c095f704f70707bd9ec8d4807b3db8f8c7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2083278984" 
	@${RM} ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d 
	@${RM} ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d" -MT "${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d" -MT ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o -o ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o ../../ModularTasks/Communications/XBEETASKS.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/3e48bec9474ad235e4d2c1e0f123cf67b0c57578 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/DSIO.o: DSIO.c  .generated_files/flags/default/627a0e8641b7116ca89c187acf7e43f97bcc6973 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DSIO.o.d 
	@${RM} ${OBJECTDIR}/DSIO.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/DSIO.o.d" -MT "${OBJECTDIR}/DSIO.o.d" -MT ${OBJECTDIR}/DSIO.o -o ${OBJECTDIR}/DSIO.o DSIO.c 
	
else
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/9b0170394f3d7180a6df3bc63ceb01e3c7bf8173 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/601c9181e7d3beb938689daaafb3ceb0f9c3de5b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/83377035/ADC.o: ../../Drivers/ADC.c  .generated_files/flags/default/56b9e0f7e771500e8012dc7846a5a55682ad03ec .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ADC.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ADC.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ADC.o.d" -MT "${OBJECTDIR}/_ext/83377035/ADC.o.d" -MT ${OBJECTDIR}/_ext/83377035/ADC.o -o ${OBJECTDIR}/_ext/83377035/ADC.o ../../Drivers/ADC.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/69cedf447d27d2fd5a77496a4b43e26d6f9ba9a8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/637866d7f9e2099597aa509c5b4e90eb8c058edd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/509585da0455510b21e9a684002fae004c7d2e67 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/1e1374156968cddfdda3f27c72ade0738ebfd6fd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/3039f911f78aa3de3073731dcc852f016119fe76 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/a94d2e927b69ca17c5433e4beb2f8f7cc8a2a97c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/e844f982d8250c936f85d61ed7c745735096f850 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/c1e7256a549a8931f279a90726261de760b3c08d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/_ext/2083278984/XBEETASKS.o: ../../ModularTasks/Communications/XBEETASKS.c  .generated_files/flags/default/9662e03a3f5c73c9aba27e1248d6819061ceac0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2083278984" 
	@${RM} ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d 
	@${RM} ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d" -MT "${OBJECTDIR}/_ext/2083278984/XBEETASKS.o.d" -MT ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o -o ${OBJECTDIR}/_ext/2083278984/XBEETASKS.o ../../ModularTasks/Communications/XBEETASKS.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/f7b975358b0a7a99271c26e10d0dbe16d62b8e1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/DSIO.o: DSIO.c  .generated_files/flags/default/32908be439091843821e81a7637b2f5e0b3a5973 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DSIO.o.d 
	@${RM} ${OBJECTDIR}/DSIO.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/DSIO.o.d" -MT "${OBJECTDIR}/DSIO.o.d" -MT ${OBJECTDIR}/DSIO.o -o ${OBJECTDIR}/DSIO.o DSIO.c 
	
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
${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../ModularTasks/Communications" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/XBSecLight.X.${IMAGE_TYPE}.hex"
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
