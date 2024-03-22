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
SOURCEFILES_QUOTED_IF_SPACED=USART.c main.c ShiftReg.c ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o ${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o
POSSIBLE_DEPFILES=${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/ShiftReg.o.d ${OBJECTDIR}/_ext/1913665898/port.o.d ${OBJECTDIR}/_ext/1614498856/event_groups.o.d ${OBJECTDIR}/_ext/1614498856/list.o.d ${OBJECTDIR}/_ext/1614498856/queue.o.d ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d ${OBJECTDIR}/_ext/1614498856/tasks.o.d ${OBJECTDIR}/_ext/1614498856/timers.o.d ${OBJECTDIR}/_ext/2145274299/heap_1.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o ${OBJECTDIR}/_ext/1913665898/port.o ${OBJECTDIR}/_ext/1614498856/event_groups.o ${OBJECTDIR}/_ext/1614498856/list.o ${OBJECTDIR}/_ext/1614498856/queue.o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ${OBJECTDIR}/_ext/1614498856/tasks.o ${OBJECTDIR}/_ext/1614498856/timers.o ${OBJECTDIR}/_ext/2145274299/heap_1.o

# Source Files
SOURCEFILES=USART.c main.c ShiftReg.c ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c ../../../../../../FreeRTOS/Source/event_groups.c ../../../../../../FreeRTOS/Source/list.c ../../../../../../FreeRTOS/Source/queue.c ../../../../../../FreeRTOS/Source/stream_buffer.c ../../../../../../FreeRTOS/Source/tasks.c ../../../../../../FreeRTOS/Source/timers.c ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c



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
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/707e2b5b6dcc1848daa602402097f8a540b9c8b9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/352b8ecb897dd021c04ee2384dd4b2fe9655ef19 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/799443801b0c13343538dfd0c48adbe386510b19 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/d256b78e8982e573568a8c35350e0cc2d9bbc2c3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/80e7c6c893f6191e80ce538b26a48eaaec415147 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/b9e2029f38813d8cb54cc955b3613f066f88668 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/3dfb951d1323fb3b54ef4f8343bdf5e04e63a88f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/99ac0e40e2893400269cea16c6c2464811d7e114 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/4a922529aed475a7cb6133793e329df467891ad8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/4c87b2a49d5c4875560ffc51f8f092417fc481ab .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/d02a9824c15a32deca8bfec5dcd4dbffdea39629 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
else
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/b1b21ae6412d24cb9698f6af5e96eaeff7ed3aa4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/fd688cdc36fbfd22e63d5644dc8940560e091017 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/21ffc065702a21516ec9f1a1c54f122e1fca7513 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
${OBJECTDIR}/_ext/1913665898/port.o: ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/21bed06455cbe2bb17dc4dafefbe3d20dc6bff4e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1913665898" 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1913665898/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT "${OBJECTDIR}/_ext/1913665898/port.o.d" -MT ${OBJECTDIR}/_ext/1913665898/port.o -o ${OBJECTDIR}/_ext/1913665898/port.o ../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1614498856/event_groups.o: ../../../../../../FreeRTOS/Source/event_groups.c  .generated_files/flags/default/c3029835c9baea7166449a95966ce55212506042 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1614498856/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1614498856/event_groups.o -o ${OBJECTDIR}/_ext/1614498856/event_groups.o ../../../../../../FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1614498856/list.o: ../../../../../../FreeRTOS/Source/list.c  .generated_files/flags/default/114dee880e2bf8dc7d91c8c73e3f18c52817b1c7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT "${OBJECTDIR}/_ext/1614498856/list.o.d" -MT ${OBJECTDIR}/_ext/1614498856/list.o -o ${OBJECTDIR}/_ext/1614498856/list.o ../../../../../../FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1614498856/queue.o: ../../../../../../FreeRTOS/Source/queue.c  .generated_files/flags/default/a914dec81c0edda965b362f881cbe621668ded0f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT "${OBJECTDIR}/_ext/1614498856/queue.o.d" -MT ${OBJECTDIR}/_ext/1614498856/queue.o -o ${OBJECTDIR}/_ext/1614498856/queue.o ../../../../../../FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1614498856/stream_buffer.o: ../../../../../../FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/df96d2953ac2c50c38c91281f079904e0238b133 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1614498856/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1614498856/stream_buffer.o -o ${OBJECTDIR}/_ext/1614498856/stream_buffer.o ../../../../../../FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1614498856/tasks.o: ../../../../../../FreeRTOS/Source/tasks.c  .generated_files/flags/default/1b6f39129b45f432b2c447d5a0f84d7b1c3c4330 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT "${OBJECTDIR}/_ext/1614498856/tasks.o.d" -MT ${OBJECTDIR}/_ext/1614498856/tasks.o -o ${OBJECTDIR}/_ext/1614498856/tasks.o ../../../../../../FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1614498856/timers.o: ../../../../../../FreeRTOS/Source/timers.c  .generated_files/flags/default/53458d88b3abd8f6e5327c29dc63d7f96086f3fb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1614498856" 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1614498856/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT "${OBJECTDIR}/_ext/1614498856/timers.o.d" -MT ${OBJECTDIR}/_ext/1614498856/timers.o -o ${OBJECTDIR}/_ext/1614498856/timers.o ../../../../../../FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/2145274299/heap_1.o: ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/94b18f044ae174c9c94408f0dc986e2a28ece5bf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/2145274299" 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/2145274299/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT "${OBJECTDIR}/_ext/2145274299/heap_1.o.d" -MT ${OBJECTDIR}/_ext/2145274299/heap_1.o -o ${OBJECTDIR}/_ext/2145274299/heap_1.o ../../../../../../FreeRTOS/Source/portable/MemMang/heap_1.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source" -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/WLD/Generic_HSD.X" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
