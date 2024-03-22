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
SOURCEFILES_QUOTED_IF_SPACED=USART.c main.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/_ext/1913665898/port.o
POSSIBLE_DEPFILES=${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1614498856/event_groups.o.d ${OBJECTDIR}/_ext/1614498856/list.o.d ${OBJECTDIR}/_ext/1614498856/queue.o.d ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d ${OBJECTDIR}/_ext/1614498856/tasks.o.d ${OBJECTDIR}/_ext/1614498856/timers.o.d ${OBJECTDIR}/_ext/2145274299/heap_1.o.d ${OBJECTDIR}/_ext/1913665898/port.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/_ext/1913665898/port.o

# Source Files
SOURCEFILES=USART.c main.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c



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
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/8cc9d7a277a6ce08acda7f96809e08f9c7c31fc3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/4cf5d2232b70461bfcc722ebb82fbbd8beb69388 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/c7ec32435d51f8bda9002217d975d18e360110b5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/f828c7c104cbec739224b223d2725376304040d7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/e3295bffd62f89a84a93ae2823b783059d01eb8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/447252aa1029135f599fe33a1a3767593ee22f73 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/3aff1ddf1575e3b1d59bddffef76c492da6b449f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/dfe0a14a40291a4e2c9822ec6a4d23fb5eb65d79 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/f31885fc53a90746813a798d9bf079f625caef7b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/9013c3f2aada206432f21c4b395f7ff98cb6db28 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
else
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/6da0444472ba65a64544c21a957ef30b44575355 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/555f31fe84b144b4330932e4d015d29f9f45c502 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/a2240757e69f5cd351547797a2c64b9261bfdfb9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/7e863bfefc0430a6c68b5262afbcd6dbd75dbb6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/720f30146db593e6bccae5d205a549c222835527 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/9bf20f866ac3a98c3914766e90ca257a346f57c6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/ea399e394932f76ce4d566bd986e5682701ca3f0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/becff87e0146af468f4d59847eddd140ad1e09b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/1f2547b8abb064e25ef61cfd6bfbe11b3bf55ada .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/719708793e0cfff566a8a240c024c20f6d6981ee .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
