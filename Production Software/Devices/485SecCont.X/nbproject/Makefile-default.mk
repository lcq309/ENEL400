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
FINAL_IMAGE=${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c ../../ModularTasks/Communications/RS485TASKS.c main.c DSIO.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o ${OBJECTDIR}/main.o ${OBJECTDIR}/DSIO.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/83377035/USART.o.d ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d ${OBJECTDIR}/_ext/1347852338/port.o.d ${OBJECTDIR}/_ext/1644529106/event_groups.o.d ${OBJECTDIR}/_ext/1644529106/heap_1.o.d ${OBJECTDIR}/_ext/1644529106/list.o.d ${OBJECTDIR}/_ext/1644529106/queue.o.d ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d ${OBJECTDIR}/_ext/1644529106/tasks.o.d ${OBJECTDIR}/_ext/1644529106/timers.o.d ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/DSIO.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o ${OBJECTDIR}/main.o ${OBJECTDIR}/DSIO.o

# Source Files
SOURCEFILES=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c ../../ModularTasks/Communications/RS485TASKS.c main.c DSIO.c



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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/6c5c88ef69c7cd3312432a1d5d90c0f4ca6c1f01 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/649da593a65f50110583b149cabbd41fbee4bc55 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/b2e1d062a475be0bc6cd1b323a0229196057e413 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/bb20b0d4ee7164cd1a2ca92618915392a3896854 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/6ec18a16b9bd7f17783a969df8b4c017a2875035 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/d95735a3dcadcdd1a0824337785c7202f7c917cf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/f75957c27a205e710e558f37a998aee119b13ff9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/cee2087ea4fbb3bfff5c4362e5b1bc34ced47748 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/3de6c7cfd41046f18e1fd41c32b97b4814b25e64 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/bab02df0236963dc038e2a9e10af4880357077e3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/_ext/2083278984/RS485TASKS.o: ../../ModularTasks/Communications/RS485TASKS.c  .generated_files/flags/default/f339567844060c14f97126ee359e487c6707b93b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2083278984" 
	@${RM} ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d 
	@${RM} ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d" -MT "${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d" -MT ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o -o ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o ../../ModularTasks/Communications/RS485TASKS.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/4dd9b618f4a7ffc28f27ebddf84a5e1a4f181838 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/DSIO.o: DSIO.c  .generated_files/flags/default/22765d282ded829bfbeae2ca34940717e004dfe0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DSIO.o.d 
	@${RM} ${OBJECTDIR}/DSIO.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/DSIO.o.d" -MT "${OBJECTDIR}/DSIO.o.d" -MT ${OBJECTDIR}/DSIO.o -o ${OBJECTDIR}/DSIO.o DSIO.c 
	
else
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/903aaee8c5341bc754dbb676bd287fc961f19472 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/af7609161b4e3e93e9a6f59807296debb32fc28e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/ceccab88f9fd073a51990021d00f2df3dc527c51 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/2b4899f75ce44bd0fde7dfc4029010a46d614149 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/fa6b2372f1fc85b4f74e2a5734c196971b9e3682 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/5b5ddbb8e588b01ad96fd9339ed0b39478f60a3c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/215d5b5d35586ae5f86a0c09c2c5b7f14fda7bd5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/894b2c133448228dd0e44be4a65e6ba55f049889 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/9a02f53d71046014c580c9f3034d11e377409199 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/1cdf94d373b91f6c931bbfb941bf34aa89c8baac .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/_ext/2083278984/RS485TASKS.o: ../../ModularTasks/Communications/RS485TASKS.c  .generated_files/flags/default/509ba12dff2ec87164216853297286147321c2c5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2083278984" 
	@${RM} ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d 
	@${RM} ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d" -MT "${OBJECTDIR}/_ext/2083278984/RS485TASKS.o.d" -MT ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o -o ${OBJECTDIR}/_ext/2083278984/RS485TASKS.o ../../ModularTasks/Communications/RS485TASKS.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/9a03f5bb62fc32ef2034d74a9ac9e48ce0afcc89 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/DSIO.o: DSIO.c  .generated_files/flags/default/58af16364829f8e36be1682c2b8a86e3189554ca .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/DSIO.o.d 
	@${RM} ${OBJECTDIR}/DSIO.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/DSIO.o.d" -MT "${OBJECTDIR}/DSIO.o.d" -MT ${OBJECTDIR}/DSIO.o -o ${OBJECTDIR}/DSIO.o DSIO.c 
	
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
${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -I"../../FreeRTOS/include" -I"../../Drivers" -I"../../ModularTasks/Communications" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/485SecCont.X.${IMAGE_TYPE}.hex"
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
