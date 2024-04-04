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
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/d34731657ede5840bec451c2e36c6730dd050fbd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/d659bd6659d765a8b7286c94df6053d9b17ccab4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/e263146a6f4aa23dc5f480a61c4742446a8ca0a0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/fc397c12b49ae61f4f77067254630d46daaafa1d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/3fc4574c79c335ccc9425141a6276d277549d754 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/31ef0373a026f58f1a7288c254c2adc1f8f58685 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/704226e767a76e1d988ea5592c6dc9f6e428f08c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/c0655941c6ed1a5f30c4f118d76399b2d0b2af0a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/c832d165efd105bdd8e29097b5038aa7a11599ba .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/20ec962ca56c8961736b864650f31eeb95155087 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/6bc7732a9442bfe2cba10978f1c3c24c22dc5b41 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
else
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/2d928cfa29f8a6e39c4a2e970fc11bb03ccb5374 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/ee87daf8a0a968e8c0cc5170b8a6f6e3cfd5ad69 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/2b075b967800072358b5c592761fdf28f4faeb23 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/3e71e36f006a3a3db9edb82823d4e1c54a2d2b0e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/79e12fe82943693a5078ac8fdea5da3615129f4d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/476101b03b7f1b5f5fd3e1834c0b18fc389b0197 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/cdd9ba4299f3c05406dead9546cd173073d3883b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/9f163f9268e26db14b5a37d01709738a35be3259 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/3f5995e3dccf0b5c7875822a71ddf8ba9ca01fac .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/d49a197f9663938b166a1a616ca438b8d033be69 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/a24019aee72afe91d8f92c07f3c539aa5e17abbb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O0 -Og -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
