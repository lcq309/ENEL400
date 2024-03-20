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
SOURCEFILES_QUOTED_IF_SPACED=F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c USART.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1980650893/port.o.d ${OBJECTDIR}/_ext/906682894/heap_1.o.d ${OBJECTDIR}/_ext/1417246959/event_groups.o.d ${OBJECTDIR}/_ext/1417246959/list.o.d ${OBJECTDIR}/_ext/1417246959/queue.o.d ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d ${OBJECTDIR}/_ext/1417246959/tasks.o.d ${OBJECTDIR}/_ext/1417246959/timers.o.d ${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o

# Source Files
SOURCEFILES=F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c USART.c main.c



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
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/439fd8ce2f913065221a242eb4bc0394175c4a5e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/875b1558de98ce60c1fca6dfe17243c8a27a29e9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/5c5c8f568ee6eadbaaaa3ca527c71bc39d0b22d3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/aab068e10e48a3a87dd4e6970e79136d5c8c7973 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/1481a323770c984abb566e401729776d459fa0c2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/23f5b76eb5e0a2371168f2a5d06e3e6784080054 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/765b1ce123d3247ae7ece0c4531f6fc3ee856c24 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/6963ec1ede1491b377782683041d79789d3f9ed5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/b919cebf0e817c21e74a41661f2e0e2182e6ec21 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/9c4897a60e69c5ac4b9e25fd6ed36d76704b60d1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/f66a93ab39b2b37e7e7cbc8192ec9b79da9ca3e2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/aacd4418e011f8b6c3242b968038efde5a3e0e6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/433e89a742a317e194cadd1deb63412609ecd2f4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/73972ba3fc48a8ad676810200fcb9209e924f22c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/dc5e33e0d607a801ad9bd7c467b8ad83c1825fe6 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/28ae39ca138427b0a4d10a337a16dfb0bcee42ec .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/a8ecf4d4370c89576d44b9e0afd9f6795bd88eb3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/67c32514647b1ec144ab86f5d8b0b618729bef00 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/1304ec746bfd3ce53cb77930a801de45d307cf90 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/b8e0bfd482a9f5afb0c9c234c87e68ccf1fed9f7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"F:/FreeRTOS/Source" -I"F:/FreeRTOS/Source/include" -I"F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx" -I"F:/GitHub/ENEL400/Software/MVP/MST/Coordinator.X" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
