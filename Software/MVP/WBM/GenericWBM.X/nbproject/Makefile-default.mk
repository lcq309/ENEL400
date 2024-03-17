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
SOURCEFILES_QUOTED_IF_SPACED=USART.c main.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o
POSSIBLE_DEPFILES=${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/_ext/1417246959/event_groups.o.d ${OBJECTDIR}/_ext/1417246959/list.o.d ${OBJECTDIR}/_ext/1417246959/queue.o.d ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d ${OBJECTDIR}/_ext/1417246959/tasks.o.d ${OBJECTDIR}/_ext/1417246959/timers.o.d ${OBJECTDIR}/_ext/1980650893/port.o.d ${OBJECTDIR}/_ext/906682894/heap_1.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o

# Source Files
SOURCEFILES=USART.c main.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c



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
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/cdc34674cb1ef4ef3148d501d8d4b09ae6203989 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/7b63a550aca40b98f6862cf58ff56b092622e3c1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/f5357eab3e5493535dfe15c0686f46514bbe730c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/758df29fd2ce11dcbe14134e1c9e2cd3dec57535 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/f18e05cba8c0d490be408031545e6d4d1c3b1322 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/de3dcb7e2dd9d8f9e09adcfcb30e656471823736 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/2aaff9b1087f9f3426969144ae4d264089e4c533 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/762669a78d3eb571177702108d7eba9028fd0009 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/29ed9567b370ddeefe04aee2cd1d657bf92170ca .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/eb649fe10c7cb528afe66ad57432d923d3dd5229 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
else
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/627554ca0c602478dfaf389b9b8dad468e81d9f7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/49fe0124b9228b812f464f619602563a92e97514 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/cca2acc4e57f42c3380267c978edf30894d10415 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/d47d95de9c1cd63ae02c066c5f440c01f3b9efa6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/681ae61df63eff7560a098c11bcd9b63399da0c9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/6c4ddf3724c94de4ba27a074f351f7dc93dfb011 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/3b62ab5fb37c88690ff49739f48e14f6dc47c777 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/9886c74e8989456aa73b5621c5d7f0e368fd910c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/a84a6ff1f30aecbc8c81a6d5591a70b376fd5061 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/ea56bf0ed981671b78c6db766f79b83b5fdb390a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
