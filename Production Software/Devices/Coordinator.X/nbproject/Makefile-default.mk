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
SOURCEFILES_QUOTED_IF_SPACED=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c main.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/main.o
POSSIBLE_DEPFILES=${OBJECTDIR}/_ext/83377035/USART.o.d ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d ${OBJECTDIR}/_ext/1347852338/port.o.d ${OBJECTDIR}/_ext/1644529106/event_groups.o.d ${OBJECTDIR}/_ext/1644529106/heap_1.o.d ${OBJECTDIR}/_ext/1644529106/list.o.d ${OBJECTDIR}/_ext/1644529106/queue.o.d ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d ${OBJECTDIR}/_ext/1644529106/tasks.o.d ${OBJECTDIR}/_ext/1644529106/timers.o.d ${OBJECTDIR}/main.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/_ext/83377035/USART.o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ${OBJECTDIR}/_ext/1347852338/port.o ${OBJECTDIR}/_ext/1644529106/event_groups.o ${OBJECTDIR}/_ext/1644529106/heap_1.o ${OBJECTDIR}/_ext/1644529106/list.o ${OBJECTDIR}/_ext/1644529106/queue.o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ${OBJECTDIR}/_ext/1644529106/tasks.o ${OBJECTDIR}/_ext/1644529106/timers.o ${OBJECTDIR}/main.o

# Source Files
SOURCEFILES=../../Drivers/USART.c ../../Drivers/ShiftReg.c ../../FreeRTOS/AVR_AVRDx/port.c ../../FreeRTOS/event_groups.c ../../FreeRTOS/heap_1.c ../../FreeRTOS/list.c ../../FreeRTOS/queue.c ../../FreeRTOS/stream_buffer.c ../../FreeRTOS/tasks.c ../../FreeRTOS/timers.c main.c



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
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/b3b93ca8a5bb810b8fe9fa6836f69063eefda0c5 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/e489eda301999e081129760dae6140916b558bcf .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/5ad4367756e06a73094962a0131f7cb6f97b81f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/ba59b47efffd7bd923fd9b6b40f2825f25b7e41d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/1ee77bda114b573be17dfd2bef5828a43e7d366d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/e2d0b3812f4559eb256ca4efa0d293049c46fb39 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/b5598190f32c45170f8a321f8d0a83fe8d63befe .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/9dffad45c459d7272c9ff5b23a62e380fd5f14ba .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/1302b0c931f58433229eb78cee9346df368bb25b .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/e403b5d88575ba195d8e0ede00fd110a9eb9264f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/d18f4cee28de1e93fc5e66ecc4c5e6a6108eac9a .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -D__DEBUG=1 -g -DDEBUG  -gdwarf-2  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
else
${OBJECTDIR}/_ext/83377035/USART.o: ../../Drivers/USART.c  .generated_files/flags/default/dd8120a644025f15f8536edee9ad983a0127f716 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/USART.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT "${OBJECTDIR}/_ext/83377035/USART.o.d" -MT ${OBJECTDIR}/_ext/83377035/USART.o -o ${OBJECTDIR}/_ext/83377035/USART.o ../../Drivers/USART.c 
	
${OBJECTDIR}/_ext/83377035/ShiftReg.o: ../../Drivers/ShiftReg.c  .generated_files/flags/default/7cf3500532dacfe44ca277872893719798baeb90 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/83377035" 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o.d 
	@${RM} ${OBJECTDIR}/_ext/83377035/ShiftReg.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT "${OBJECTDIR}/_ext/83377035/ShiftReg.o.d" -MT ${OBJECTDIR}/_ext/83377035/ShiftReg.o -o ${OBJECTDIR}/_ext/83377035/ShiftReg.o ../../Drivers/ShiftReg.c 
	
${OBJECTDIR}/_ext/1347852338/port.o: ../../FreeRTOS/AVR_AVRDx/port.c  .generated_files/flags/default/2bea839a4f844c3acece70b2e42a1a5cc64914c .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1347852338" 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o.d 
	@${RM} ${OBJECTDIR}/_ext/1347852338/port.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT "${OBJECTDIR}/_ext/1347852338/port.o.d" -MT ${OBJECTDIR}/_ext/1347852338/port.o -o ${OBJECTDIR}/_ext/1347852338/port.o ../../FreeRTOS/AVR_AVRDx/port.c 
	
${OBJECTDIR}/_ext/1644529106/event_groups.o: ../../FreeRTOS/event_groups.c  .generated_files/flags/default/a324f2d0c2399573144d2735b1f0a03276126ff1 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/event_groups.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT "${OBJECTDIR}/_ext/1644529106/event_groups.o.d" -MT ${OBJECTDIR}/_ext/1644529106/event_groups.o -o ${OBJECTDIR}/_ext/1644529106/event_groups.o ../../FreeRTOS/event_groups.c 
	
${OBJECTDIR}/_ext/1644529106/heap_1.o: ../../FreeRTOS/heap_1.c  .generated_files/flags/default/764d9b27ef38b3bf3a24bb55bd79ec8b64b6a820 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/heap_1.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT "${OBJECTDIR}/_ext/1644529106/heap_1.o.d" -MT ${OBJECTDIR}/_ext/1644529106/heap_1.o -o ${OBJECTDIR}/_ext/1644529106/heap_1.o ../../FreeRTOS/heap_1.c 
	
${OBJECTDIR}/_ext/1644529106/list.o: ../../FreeRTOS/list.c  .generated_files/flags/default/822e15f8dcac0238f77cdc2db4e010ac08ba6e99 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/list.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT "${OBJECTDIR}/_ext/1644529106/list.o.d" -MT ${OBJECTDIR}/_ext/1644529106/list.o -o ${OBJECTDIR}/_ext/1644529106/list.o ../../FreeRTOS/list.c 
	
${OBJECTDIR}/_ext/1644529106/queue.o: ../../FreeRTOS/queue.c  .generated_files/flags/default/205e88ff1f250324a2ae529e8ce1b2ac2422f42f .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/queue.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT "${OBJECTDIR}/_ext/1644529106/queue.o.d" -MT ${OBJECTDIR}/_ext/1644529106/queue.o -o ${OBJECTDIR}/_ext/1644529106/queue.o ../../FreeRTOS/queue.c 
	
${OBJECTDIR}/_ext/1644529106/stream_buffer.o: ../../FreeRTOS/stream_buffer.c  .generated_files/flags/default/598d22ebab31b48203b846e364612387c76b1f2 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/stream_buffer.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT "${OBJECTDIR}/_ext/1644529106/stream_buffer.o.d" -MT ${OBJECTDIR}/_ext/1644529106/stream_buffer.o -o ${OBJECTDIR}/_ext/1644529106/stream_buffer.o ../../FreeRTOS/stream_buffer.c 
	
${OBJECTDIR}/_ext/1644529106/tasks.o: ../../FreeRTOS/tasks.c  .generated_files/flags/default/e4273f730dd559cde529c8409940af81cbf7c179 .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/tasks.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT "${OBJECTDIR}/_ext/1644529106/tasks.o.d" -MT ${OBJECTDIR}/_ext/1644529106/tasks.o -o ${OBJECTDIR}/_ext/1644529106/tasks.o ../../FreeRTOS/tasks.c 
	
${OBJECTDIR}/_ext/1644529106/timers.o: ../../FreeRTOS/timers.c  .generated_files/flags/default/1a14c09b43499d8fb95d48f3aae4ae3ac863ea7d .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}/_ext/1644529106" 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o.d 
	@${RM} ${OBJECTDIR}/_ext/1644529106/timers.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT "${OBJECTDIR}/_ext/1644529106/timers.o.d" -MT ${OBJECTDIR}/_ext/1644529106/timers.o -o ${OBJECTDIR}/_ext/1644529106/timers.o ../../FreeRTOS/timers.c 
	
${OBJECTDIR}/main.o: main.c  .generated_files/flags/default/c1df49bf9bfff47b09f9b475d3669e233cfff0e .generated_files/flags/default/da39a3ee5e6b4b0d3255bfef95601890afd80709
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/main.o.d 
	@${RM} ${OBJECTDIR}/main.o 
	${MP_CC} $(MP_EXTRA_CC_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -c  -x c -D__$(MP_PROCESSOR_OPTION)__   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall -DXPRJ_default=$(CND_CONF)  $(COMPARISON_BUILD)      -MD -MP -MF "${OBJECTDIR}/main.o.d" -MT "${OBJECTDIR}/main.o.d" -MT ${OBJECTDIR}/main.o -o ${OBJECTDIR}/main.o main.c 
	
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
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -D__DEBUG=1  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"   -gdwarf-2 -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group  -Wl,--defsym=__MPLAB_DEBUG=1,--defsym=__DEBUG=1
	@${RM} ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.hex 
	
else
${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} ${DISTDIR} 
	${MP_CC} $(MP_EXTRA_LD_PRE) -mcpu=$(MP_PROCESSOR_OPTION) -Wl,-Map=${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.map  -DXPRJ_default=$(CND_CONF)  -Wl,--defsym=__MPLAB_BUILD=1   -mdfp="${DFP_DIR}/xc8"  -Wl,--gc-sections -O1 -ffunction-sections -fdata-sections -fshort-enums -fno-common -funsigned-char -funsigned-bitfields -I"../../Drivers" -I"../../FreeRTOS/include" -I"FreeRTOSConfig" -I"../../FreeRTOS/AVR_AVRDx" -Wall     $(COMPARISON_BUILD) -Wl,--memorysummary,${DISTDIR}/memoryfile.xml -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  -o ${DISTDIR}/Coordinator.X.${IMAGE_TYPE}.${DEBUGGABLE_SUFFIX}  ${OBJECTFILES_QUOTED_IF_SPACED}      -Wl,--start-group  -Wl,-lm -Wl,--end-group 
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
