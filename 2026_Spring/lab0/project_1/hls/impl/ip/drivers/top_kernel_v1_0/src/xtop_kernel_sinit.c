// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xtop_kernel.h"

extern XTop_kernel_Config XTop_kernel_ConfigTable[];

#ifdef SDT
XTop_kernel_Config *XTop_kernel_LookupConfig(UINTPTR BaseAddress) {
	XTop_kernel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XTop_kernel_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XTop_kernel_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XTop_kernel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTop_kernel_Initialize(XTop_kernel *InstancePtr, UINTPTR BaseAddress) {
	XTop_kernel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTop_kernel_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTop_kernel_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XTop_kernel_Config *XTop_kernel_LookupConfig(u16 DeviceId) {
	XTop_kernel_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XTOP_KERNEL_NUM_INSTANCES; Index++) {
		if (XTop_kernel_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XTop_kernel_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XTop_kernel_Initialize(XTop_kernel *InstancePtr, u16 DeviceId) {
	XTop_kernel_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XTop_kernel_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XTop_kernel_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

