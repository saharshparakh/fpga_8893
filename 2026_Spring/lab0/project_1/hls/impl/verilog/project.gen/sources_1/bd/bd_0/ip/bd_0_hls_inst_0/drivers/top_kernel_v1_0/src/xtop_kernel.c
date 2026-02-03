// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2025.1.1 (64-bit)
// Tool Version Limit: 2025.05
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xtop_kernel.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XTop_kernel_CfgInitialize(XTop_kernel *InstancePtr, XTop_kernel_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XTop_kernel_Start(XTop_kernel *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL) & 0x80;
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XTop_kernel_IsDone(XTop_kernel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XTop_kernel_IsIdle(XTop_kernel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XTop_kernel_IsReady(XTop_kernel *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XTop_kernel_EnableAutoRestart(XTop_kernel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XTop_kernel_DisableAutoRestart(XTop_kernel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_AP_CTRL, 0);
}

void XTop_kernel_Set_a_r(XTop_kernel *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_A_R_DATA, (u32)(Data));
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_A_R_DATA + 4, (u32)(Data >> 32));
}

u64 XTop_kernel_Get_a_r(XTop_kernel *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_A_R_DATA);
    Data += (u64)XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_A_R_DATA + 4) << 32;
    return Data;
}

void XTop_kernel_Set_b_r(XTop_kernel *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_B_R_DATA, (u32)(Data));
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_B_R_DATA + 4, (u32)(Data >> 32));
}

u64 XTop_kernel_Get_b_r(XTop_kernel *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_B_R_DATA);
    Data += (u64)XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_B_R_DATA + 4) << 32;
    return Data;
}

void XTop_kernel_Set_sum_r(XTop_kernel *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_SUM_R_DATA, (u32)(Data));
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_SUM_R_DATA + 4, (u32)(Data >> 32));
}

u64 XTop_kernel_Get_sum_r(XTop_kernel *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_SUM_R_DATA);
    Data += (u64)XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_SUM_R_DATA + 4) << 32;
    return Data;
}

void XTop_kernel_InterruptGlobalEnable(XTop_kernel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_GIE, 1);
}

void XTop_kernel_InterruptGlobalDisable(XTop_kernel *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_GIE, 0);
}

void XTop_kernel_InterruptEnable(XTop_kernel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_IER);
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_IER, Register | Mask);
}

void XTop_kernel_InterruptDisable(XTop_kernel *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_IER);
    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_IER, Register & (~Mask));
}

void XTop_kernel_InterruptClear(XTop_kernel *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XTop_kernel_WriteReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_ISR, Mask);
}

u32 XTop_kernel_InterruptGetEnabled(XTop_kernel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_IER);
}

u32 XTop_kernel_InterruptGetStatus(XTop_kernel *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XTop_kernel_ReadReg(InstancePtr->Control_BaseAddress, XTOP_KERNEL_CONTROL_ADDR_ISR);
}

