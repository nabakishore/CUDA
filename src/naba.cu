#include <stdio.h>

__global__ void add( int *a, int *b, int *c) {
	*c = *a + *b;
}

__global__ void array_add (int *a, int *b, int *c, int sz) {
	int idx = threadIdx.x + blockIdx.x * blockDim.x;

	if ( idx < sz)
		c[idx] = a[idx] + b[idx];

}
int main(void) {
	int a, b, c;
	int *dev_a, *dev_b, *dev_c;
	int size = sizeof(int);
	cudaMalloc((void **)&dev_a, size);
	cudaMalloc((void **)&dev_b, size);
	cudaMalloc((void **)&dev_c, size);

	a = 2;
	b = 7;
	cudaMemcpy(dev_a, &a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, &b, size, cudaMemcpyHostToDevice);
	add<<< 1, 1 >>>(dev_a, dev_b, dev_c);

	cudaMemcpy(&c, dev_c, size, cudaMemcpyDeviceToHost);

	printf("%d + %d = %d\n", a, b, c);

	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);

	size = sizeof(int) * 2048;

	int *x = malloc(size);
	int *y = malloc(size);

	memset(x, 1, 2048);
	memset(y, 2, 2048);

	cudaMalloc((void **)&dev_a, size);
        cudaMalloc((void **)&dev_b, size);
        cudaMalloc((void **)&dev_c, size);

	cudaMemcpy(dev_a, x, size, cudaMemcpyHostToDevice);
        cudaMemcpy(dev_b, y, size, cudaMemcpyHostToDevice);

	int threadsPerBlock = 1024;
	int blocksPerGrid =
            (2048 + threadsPerBlock - 1) / threadsPerBlock;


}
