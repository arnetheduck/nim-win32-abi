# Simple test application: prints process information using the
# generated Win32 API bindings (win32/abi).

import win32/abi/processthreadsapi
import win32/abi/sysinfoapi
import win32/abi/psapi

echo "Process information (win32_abi)"
echo "==============================="

# Current process and thread
let
  pid = GetCurrentProcessId()
  tid = GetCurrentThreadId()
  hProcess = GetCurrentProcess()

echo "Process ID:   ", pid
echo "Thread ID:    ", tid
doAssert pid != 0'u32
doAssert tid != 0'u32

# System information
var si: SYSTEM_INFO
GetSystemInfo(addr(si))
echo "Processors:   ", si.dwNumberOfProcessors
echo "Page size:    ", si.dwPageSize
echo "Granularity:  ", si.dwAllocationGranularity
doAssert si.dwNumberOfProcessors > 0'u32
doAssert si.dwPageSize > 0'u32

# Process times (100ns units)
var creationTime, exitTime, kernelTime, userTime: FILETIME
doAssert GetProcessTimes(
  hProcess, addr(creationTime), addr(exitTime), addr(kernelTime), addr(userTime)
).int32 == TRUE
echo "Kernel time:  ",
  kernelTime.dwHighDateTime * 4294967296'u64 + kernelTime.dwLowDateTime
echo "User time:    ", userTime.dwHighDateTime * 4294967296'u64 + userTime.dwLowDateTime

# Memory usage
var pmc: PROCESS_MEMORY_COUNTERS
doAssert GetProcessMemoryInfo(
  hProcess, addr(pmc), sizeof(PROCESS_MEMORY_COUNTERS).uint32
).int32 == TRUE
echo "Working set:  ", pmc.WorkingSetSize, " bytes"
doAssert pmc.WorkingSetSize > 0

# System time
var st: SYSTEMTIME
GetSystemTime(addr(st))
echo "System time:  ",
  st.wYear, ".", st.wMonth, ".", st.wDay, " ", st.wHour, ":", st.wMinute, ":",
  st.wSecond
doAssert st.wYear >= 2025'u16

echo "OK"
