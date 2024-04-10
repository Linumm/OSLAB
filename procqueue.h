// Project 2: MLFQ & MoQ structure implementation here.

// MLFQ:
// 4-level queue, 0~2: RR, 3: RR+Prior
struct mlfq {
	struct spinlock lock;			// lock
	struct proc queue[3][NPROC];	// 4-lv process array 
	int toplv;						// top lv queue which is not empty in flow
}


// MoQ:
// 
