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

	size = sizeof(int) * 4096;

	int *x = (int *)malloc(size);
	int *y = (int *)malloc(size);
	int *z = (int *)malloc(size);
	
	memset(x, 1, size);
	memset(y, 2, size);

	cudaMalloc((void **)&dev_a, size);
        cudaMalloc((void **)&dev_b, size);
        cudaMalloc((void **)&dev_c, size);

	x[0] = 5;
	y[0] = 5;

	x[1024] = 2;
	y[1024] = 2;

	x[2047] = 1;
	y[2047] = 1;
	cudaMemcpy(dev_a, x, size, cudaMemcpyHostToDevice);
        cudaMemcpy(dev_b, y, size, cudaMemcpyHostToDevice);

	int threadsPerBlock = 1024;
	int blocksPerGrid =
            (4096 + threadsPerBlock - 1) / threadsPerBlock;

	array_add<<< blocksPerGrid, threadsPerBlock >>>(dev_a, dev_b, dev_c, 4096);

	cudaMemcpy(z, dev_c, size, cudaMemcpyDeviceToHost);
	for (int j = 0; j < 4096; j++) {
		printf("%d ", z[j]);
	}
	printf("\n");

	free(x);
	free(y);
	free(z);

        cudaFree(dev_a);
        cudaFree(dev_b);
        cudaFree(dev_c);

}
