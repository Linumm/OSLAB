#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char* argv[])
{
	char* student_id = "2020002542";
	int pid = getpid();
	int gpid = getgpid();

	printf(1, "My student id is %s\n", student_id);
	printf(1, "My pid is %d\n", pid);
	printf(1, "My gpid is %d\n", gpid);

	exit();
}
