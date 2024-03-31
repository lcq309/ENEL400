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
SOURCEFILES_QUOTED_IF_SPACED=../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c USART.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1913665898/port.o.d ${OBJECTDIR}/_ext/1614498856/event_groups.o.d ${OBJECTDIR}/_ext/1614498856/list.o.d ${OBJECTDIR}/_ext/1614498856/queue.o.d ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d ${OBJECTDIR}/_ext/1614498856/tasks.o.d ${OBJECTDIR}/_ext/1614498856/timers.o.d ${OBJECTDIR}/_ext/2145274299/heap_1.o.d ${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o

# Source Files
SOURCEFILES=../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c USART.c main.c



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
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/4c6bb8563dedd7285abe213b78180be402c88740 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/bca03a9e7abe551c0b7a8a8525872a9792992a66 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/9b5f804c653df213ecae737d09864bfb21003325 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/32a3ea744a425635cc368d9f81f1077cd2f5e4e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/c62ebc9003465f79240fa97f0207af1a06b4f6e8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/73cd02f237addcfa5c9056d606cdd42af4675a4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/c3a906d86c895a325adb295ff2c50864fd9a2b76 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/740a8a43e0b9f4d8c4471fefa6a9f83bbb8d54b0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/32f809be826937e0945f321ab64dcee126bcd680 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/5bc04a892b0359a740f64d7017e263eda4ef2214 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/b922fa43832deef1ca2b9ab82c4cd212c48420be .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/ff64bb16d48d498074eb98b87f0d2cc3b86664fa .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/92bb85aa214b2fdbc09271edf54b415a678f6d24 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/fd215a73c1a7c90097cd4f5789702385d3d610b6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/f17906e01a6a272bcb34fa5f3c62ec581e12d6aa .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/e084f808e6e6609462561135d27ed1b6cd5958b5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/f23c721a78539f093b0e3a66dfce6fe17ee83965 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/af7f3c185d939aa84dde53c651480f8e8dacd96a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/1fbbbe595bbf5574af5b9d01a6c48b217f21a299 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/db14103eb755c4c91c891fbb5adf9ad7e935c220 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O2 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"../../../../../../FreeRTOS/Source/include" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
