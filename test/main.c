#include "grid_client.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <unistd.h>
#include <getopt.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

#define OIO_NS ("OPENIO")

void usage(FILE *f)
{
	fprintf(f, "Usage: ./test [-h] -i <ip> -p <port>\n");
	fprintf(f, "\n");
	fprintf(f, "options:\n");
	fprintf(f, "   -o <ip>    The IP address of the Open IO conscience.\n");
	fprintf(f, "   -p <port>  The port of the Open IO conscience.\n");
}

int main(int argc, char **argv)
{
	int opt;
	gs_grid_storage_t *storage;
	gs_error_t *err = NULL;
	int opt_help = 0;
	char * opt_conscience_port = NULL;
	char * opt_conscience_ip = NULL;

	// Parse command line options.
	while ((opt = getopt(argc, argv, "hp:i:")) != -1)
	{
		switch (opt) {
			case 'h':
				opt_help = 1;
				break;
			case 'p':
				opt_conscience_port = optarg;
				break;
			case 'i':
				opt_conscience_ip = optarg;
				break;
			default:
				usage(stderr);
				exit(1);
		}
	}

	// Show help message and exit, if it was requested.
	if (opt_help)
	{
		usage(stdout);
		exit(0);
	}

	// Check that both a Conscience IP and port are provided.
	if (!opt_conscience_ip || !opt_conscience_port)
	{
		usage(stderr);
		exit(1);
	}

	// Populate Open IO config file with the config we want.
	if (mkdir("/root/.oio", 0) == -1 && errno != EEXIST)
	{
		fprintf(stderr, "error: could not create config directory: %s\n", strerror(errno));
		exit(1);
	}
	FILE * config_file = fopen("/root/.oio/sds.conf", "w");
	if (config_file == NULL)
	{
		fprintf(stderr, "error: could not create config file: %s\n", strerror(errno));
		exit(1);
	}
	if (fprintf(config_file, "[OPENIO]\nconscience=%s:%s\n", opt_conscience_ip, opt_conscience_port) < 0)
	{
		fprintf(stderr, "error: could not write initial config file: %s\n", strerror(errno));
		exit(1);
	}
	fclose(config_file);

	// Get a handle to a META0 OpenIO server. Then close it imediately.
	// This is just a test to see if we have access to the META0 server.
	storage = gs_grid_storage_init(OIO_NS, &err);
	if (storage == NULL)
	{
		fprintf(stderr, "could not connect to OpenIO: %s\n", err->msg);
		return (1);
	}
	gs_grid_storage_free(storage);

	return (0);
}
