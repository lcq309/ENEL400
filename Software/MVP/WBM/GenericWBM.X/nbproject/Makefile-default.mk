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
	${MAKE}  -f nbproject/Makefile-default.mk ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=AVR128DA28
# ------------------------------------------------------------------------------------
# Rules for buildStep: compile
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/90228e3e65e2262b932002e544d3325a12aaa705 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/c07ec3db32ea20296d983a1ea38bfeed05b14a60 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/790a588d2f74e27f4881e2f3134854920353d63c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/f6f52253863cc45e5a002525d3013893ba357fe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/9183a192b4e0d2e7f0f6c512fee873d713b4035a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/c7db6d50fb882e7b776149ec08f7caee9e9f841e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/f5a7a3f6ea66c43cd064a2d2ffef7960175e1be4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/3ea7ec6f195990123772b2eb2b30112b6eef80e1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/4e205927a0bf60f9ce99001371740e2f63b577fd .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/8b687f874905bcac170990ea5900137e53982f2d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/aee8067a21cbc74707c3c4221822e7b52e9326b5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/e44b7db55c5bdc37028be0ede9504d19f808eedb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/210d25ee010d4ec6cfe1ffe01e054d2e4a0a8a46 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/215c070b3fde3970f87048a1529512c50705a075 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/b98b848e7bc8fa3e4004f6cc7ae785e30bbe5002 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/f63d3bb0375ede64181d20ddf8d09ef0d20d4729 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/ef24fcb44105901516a3b9a1b0326121f619d666 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/1c47b5c576dffdad7df26c5086cfae589d1173fb .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/71e3689a3900d283c122f1ad3000918cad13acc3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/c8a6cc2fa6bd23bb9edd30d23a6f238d1bca5735 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"F:/GitHub/ENEL400/Software/MVP/WBM/GenericWBM.X" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
