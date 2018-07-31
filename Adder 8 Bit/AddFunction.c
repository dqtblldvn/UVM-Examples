#include "stdio.h"
#include "svdpi.h"
#include "AddFunction.h"

void AddFunction(const svBitVecVal* A, const svBitVecVal* B, svBitVecVal* result)
{
	//svBitVecVal* result;
	*result = *A + *B;
}
