#include "grid_client.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#define OIO_NS ("OPENIO")

int main()
{
	gs_grid_storage_t *storage;
	gs_error_t *err = NULL;

	storage = gs_grid_storage_init(OIO_NS, &err);
	if (storage == NULL) {
		fprintf(stderr, "could not connect to OpenIO: %s\n", err->msg);
		return (1);
	}
	gs_grid_storage_free(storage);
		
	return (0);
}
