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
FINAL_IMAGE=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=elf
FINAL_IMAGE=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/56b571c850ca6bacd84f4d8f060e1362a4f5b127 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/3d52b64f6085a98e4862927db71cccb54fc1a7f1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/245f847c88d9edc55a3aeee5ca66b9009af3011e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/a31ee5c8933e13c2c5b69964d668b1e307a3ec4b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/35a40240720a8bd073c65248f795f9a24ee94511 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/fafc16470204b1aec90128884ca05f085968e357 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/5faf99c4b8518301218daa8217b7cbdcd9a048df .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/9ca6b5eb0ce6c8c3318486a40faac9980f9730b0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/5c4e74e7bd65c9b1a28a8dc62a285de5554d6118 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/8dede282bb6b15ac2cee74957e03c6c7074ec59 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/e37a0611abab58fc44b76407e5b63a4555e6b24d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
else
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/ea0ff55fa618b2147f563b707f0ceccb032d1e7e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/4cc036a438266c7663d10bae333227845d381077 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/b5823fa60bf6ea6a9c96c807573ee16e0c8a27da .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/6e44f5d18fe04a493c70e0233f31a816a21b324f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/5e0b012d1cee9acde4b82e484594f4221e87bb01 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/2b21214e3df7311fc2ea69612e8409457fc5efa5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/1fa3b688263770ee0f8335823bfc4b776ab81cf2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/d0a2d5c114afaa1a1d1d6b32178fb9b627c42053 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/3ce51310f7232b5c88c217455e46bcb58c6259d6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/fc0f1a9c8b5ce793aec4d5b27740e2f4ff60cd28 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/98a5734e3c97151479eb88225e7dd9b5c97d9218 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true} -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
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
${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true}     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 ${optimization-options.prefix}+asm${optimization-options.separator}${optimization-assembler-files.true}${optimization-options.separator}-speed,+space${optimization-options.separator}${optimization-debug.true}${optimization-options.separator}${local-generation.false} ${what-to-do.prefix}ignore --mode=free ${preprocess-assembler.trueemission} -N255 -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"FreeRTOSConfig" ${warn-level.prefix}-3 ${asmlist.true}     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
	${MP_CC_DIR}\\avr-objcopy -O ihex "${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}" "${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.hex"
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
