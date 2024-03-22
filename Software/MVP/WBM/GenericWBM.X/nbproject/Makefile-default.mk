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
SOURCEFILES_QUOTED_IF_SPACED=F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c USART.c main.c ShiftReg.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/1980650893/port.o.d ${OBJECTDIR}/_ext/906682894/heap_1.o.d ${OBJECTDIR}/_ext/1417246959/event_groups.o.d ${OBJECTDIR}/_ext/1417246959/list.o.d ${OBJECTDIR}/_ext/1417246959/queue.o.d ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d ${OBJECTDIR}/_ext/1417246959/tasks.o.d ${OBJECTDIR}/_ext/1417246959/timers.o.d ${OBJECTDIR}/USART.o.d ${OBJECTDIR}/main.o.d ${OBJECTDIR}/ShiftReg.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/1980650893/port.o ${OBJECTDIR}/_ext/906682894/heap_1.o ${OBJECTDIR}/_ext/1417246959/event_groups.o ${OBJECTDIR}/_ext/1417246959/list.o ${OBJECTDIR}/_ext/1417246959/queue.o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o ${OBJECTDIR}/_ext/1417246959/tasks.o ${OBJECTDIR}/_ext/1417246959/timers.o ${OBJECTDIR}/USART.o ${OBJECTDIR}/main.o ${OBJECTDIR}/ShiftReg.o

# Source Files
SOURCEFILES=F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c F:/FreeRTOS/Source/portable/MemMang/heap_1.c F:/FreeRTOS/Source/event_groups.c F:/FreeRTOS/Source/list.c F:/FreeRTOS/Source/queue.c F:/FreeRTOS/Source/stream_buffer.c F:/FreeRTOS/Source/tasks.c F:/FreeRTOS/Source/timers.c USART.c main.c ShiftReg.c



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
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/c896505eaea51bff8fcd77d8ffdd17054485030 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/a7085dbd94e96da265b466cb69c7018f5790fdb1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/49b05e9f724323d4f585cb288fb39eee95ad3cd0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/d9466b6e0af2812eec2be444dcdcb971dec2eb74 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/281d0443b8d00d74f3bbcd473517b991238fba40 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/a44a2fa9967b66a5fef47234c01ba23b8f8a1b52 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/27786a9ab0cd154307eabe5600a01ceea580f4c2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/a2e29b186d1b8f29d481efacf781d1aafcca3be4 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/be4d59ce14f5cbca5badde1f2aa0998e46b234d0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/1b4db7512662e1ff20b14d202f608f5f7a0b58ba .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/e553497618cbd29d676b70401460e5a57fc64011 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
else
${OBJECTDIR}/_ext/1980650893/port.o: F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c  .generated_files/flags/default/18864566786e30a0d24d15af22f5b4802a6b34b7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1980650893" 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1980650893/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT "${OBJECTDIR}/_ext/1980650893/port.o.d" -MT ${OBJECTDIR}/_ext/1980650893/port.o -o ${OBJECTDIR}/_ext/1980650893/port.o F:/FreeRTOS/Source/portable/GCC/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/906682894/heap_1.o: F:/FreeRTOS/Source/portable/MemMang/heap_1.c  .generated_files/flags/default/1321ed3f5c4f073b7b307459ea698c1160cbc709 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/906682894" 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/906682894/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT "${OBJECTDIR}/_ext/906682894/heap_1.o.d" -MT ${OBJECTDIR}/_ext/906682894/heap_1.o -o ${OBJECTDIR}/_ext/906682894/heap_1.o F:/FreeRTOS/Source/portable/MemMang/heap_1.c 
	
${OBJECTDIR}/_ext/1417246959/event_groups.o: F:/FreeRTOS/Source/event_groups.c  .generated_files/flags/default/5f3ccac31bb8f2ce99008ddf36811b7301d38e6e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1417246959/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1417246959/event_groups.o -o ${OBJECTDIR}/_ext/1417246959/event_groups.o F:/FreeRTOS/Source/event_groups.c 
	
${OBJECTDIR}/_ext/1417246959/list.o: F:/FreeRTOS/Source/list.c  .generated_files/flags/default/b1c8b9d64b6679e9919927c7399c8b2e9da0d5e7 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT "${OBJECTDIR}/_ext/1417246959/list.o.d" -MT ${OBJECTDIR}/_ext/1417246959/list.o -o ${OBJECTDIR}/_ext/1417246959/list.o F:/FreeRTOS/Source/list.c 
	
${OBJECTDIR}/_ext/1417246959/queue.o: F:/FreeRTOS/Source/queue.c  .generated_files/flags/default/110c287045baf5fe82c070ceab0d17efb84e36d3 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT "${OBJECTDIR}/_ext/1417246959/queue.o.d" -MT ${OBJECTDIR}/_ext/1417246959/queue.o -o ${OBJECTDIR}/_ext/1417246959/queue.o F:/FreeRTOS/Source/queue.c 
	
${OBJECTDIR}/_ext/1417246959/stream_buffer.o: F:/FreeRTOS/Source/stream_buffer.c  .generated_files/flags/default/5f316f9922975135a2e2a3fad4073ec06e62eea0 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1417246959/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1417246959/stream_buffer.o -o ${OBJECTDIR}/_ext/1417246959/stream_buffer.o F:/FreeRTOS/Source/stream_buffer.c 
	
${OBJECTDIR}/_ext/1417246959/tasks.o: F:/FreeRTOS/Source/tasks.c  .generated_files/flags/default/89c8154f8988e9c75cf40c592d4078de0324fd92 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT "${OBJECTDIR}/_ext/1417246959/tasks.o.d" -MT ${OBJECTDIR}/_ext/1417246959/tasks.o -o ${OBJECTDIR}/_ext/1417246959/tasks.o F:/FreeRTOS/Source/tasks.c 
	
${OBJECTDIR}/_ext/1417246959/timers.o: F:/FreeRTOS/Source/timers.c  .generated_files/flags/default/be2aed8492b5b71285825644803ede1d053decf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1417246959" 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1417246959/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT "${OBJECTDIR}/_ext/1417246959/timers.o.d" -MT ${OBJECTDIR}/_ext/1417246959/timers.o -o ${OBJECTDIR}/_ext/1417246959/timers.o F:/FreeRTOS/Source/timers.c 
	
${OBJECTDIR}/USART.o: USART.c  .generated_files/flags/default/2a5e8b21914f2dafb2d80dd39188d3c133094783 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/USART.o.d 
	@${RM} ${OBJECTDIR}/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/USART.o.d" -MT "${OBJECTDIR}/USART.o.d" -MT ${OBJECTDIR}/USART.o -o ${OBJECTDIR}/USART.o USART.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/4ce3beeb21039cf1f01c62daf3d17cfc7de54ca2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
${OBJECTDIR}/ShiftReg.o: ShiftReg.c  .generated_files/flags/default/5614f8d5d1ca19c0754912a4a2b3e9ebeff7ae14 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)  -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     -MD -MP -MF "${OBJECTDIR}/ShiftReg.o.d" -MT "${OBJECTDIR}/ShiftReg.o.d" -MT ${OBJECTDIR}/ShiftReg.o -o ${OBJECTDIR}/ShiftReg.o ShiftReg.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -D__MPLAB_DEBUGGER_SIMULATOR=1 -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1,--defsym=__MPLAB_DEBUGGER_SIMULATOR=1
	@${RM} ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../../../../../FreeRTOS/Source/include" -I"../../../../../../FreeRTOS/Source" -I"FreeRTOSConfig" -I"../../../../../../FreeRTOS/Source/portable/GCC/AVR_AVRDx" -Wall -gdwarf-3 -mconst-data-in-progmem -mno-const-data-in-config-mapped-progmem     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/GenericWBM.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
