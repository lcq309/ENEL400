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
FINAL_IMAGE=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
SOURCEFILES_QUOTED_IF_SPACED=../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c USART.c main.c ShiftReg.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1913665898/port.o.d ${OBJECTDIR}/_ext/1614498856/event_groups.o.d ${OBJECTDIR}/_ext/1614498856/list.o.d ${OBJECTDIR}/_ext/1614498856/queue.o.d ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d ${OBJECTDIR}/_ext/1614498856/tasks.o.d ${OBJECTDIR}/_ext/1614498856/timers.o.d ${OBJECTDIR}/_ext/2145274299/heap_1.o.d ${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/ShiftReg.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o

# Source Files
SOURCEFILES=../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c USART.c main.c ShiftReg.c



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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/4e32feb50bcf3b6f1bd785815141e1c97d4b3090 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/810167b4849d5201d83af0f9653a5155d7582b5e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/f80c446ef8f23827d639a38a1badc22b8b2537c7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/3a9cd34db82bd8942a6d664de8eb4d95fdc8c5c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/3824b4c5b5de7a9070e94f5e918e8327d7baf505 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/b5ba0eb3ebed6ef6408ec6ed0d989730f576d8c5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/8e4b53e81d88b86b01a2e6e477fd00b8491e213e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/ddaaeaaddec758529b046ae95b0be174345e21dc .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/3806b1dd83eaf744bc0f68a03ea1639562a42bf1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/4848ba2a61d89c0cfb13af912bee5afb93a24d14 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/6dcecef7482a10a5ed3b8b3b47ba54f67d71095b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
else
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/5cec70ec897e66d1d95a67560b48d1387be5b5a9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/27abf4c09e43dfe460672dfa5274ba21510f693b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/31eb13bcda9b41a61e291148a358a8b0e7602a11 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/c5d7b2c18d11200c3950eece8e7aeb5e38ee8200 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/c248ad30b3eb8f7b346482d423bb7244a59ce651 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/235a40f417df65dcaf64c876e8dba8cb315c9462 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/c0ec074d8294b7f24e6a2187ac71854fc6c23abe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/eb9620e230d7ce3154f210357fb07c79f1684464 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/2ad314e8c08f3b4d66341c75398816a2161f733e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/849344966ed1de5523e5d9c437c97f5071981c9f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/d79905961f96e9181623f9b970d6a0525117aae3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
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
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true}     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" ${warn-level.prefix}-3 ${asmlist.true}     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex"
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
