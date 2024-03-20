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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/abfa5a86fe9ca470c42ec0d327e37d508ac21510 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/722c121378d5ba72188abb40c4b162a6ce30c77d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/b436f1d8fff747f3bff2f5fefbf4ca7b9c506e78 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/17f00086b64c6d529098d12b9423ec8d243d9e49 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/c7c943974afdf49938f7644d4e2c028436241d00 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/2c2d35a7553f770c8cc93870a97aaa9952e982bb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/e6545dcfb422effebd7d09af7c627ffc1f8181a9 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/37e137cc3bbcb2e1097279106f74300e0e429c44 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/3dad02307320c5d10c8cd17c378e0ba4ca35f0cd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/e4f91ff46c949f75de68331574e3d8ed3825109f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/e363be6b303b22a3250609924c1b3f8a4d1b1bee .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/eaae9a8c8da7238bee36dd8a293e878f50ebde0f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/12ad81e38df65da7241dd726546d537111456a15 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/55bc9022f7f7dc6c0aa583b4d72a8bd941a4a95c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/676635d4e57db21ad1df3ff001a6fed88aa73a37 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/97924c66eb99d2718a8e57f7313efdc71bc6fac5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/4cae20c3fd0e2e42f6799ed033ad4202cbfc0bf8 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/d05667858f2b65b26ed08f055829ad4fbe6e3018 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/12e10e392795b26b0c60579fabb19453c5b69e41 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/f068bcddbdbf4bb5462fc725a76552a9acc6b6c2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Generic_HSD.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
