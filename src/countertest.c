#include <time.h>
#include <stdio.h>
#include <assert.h>
#include "lmdb_counter.h"

int main() {
    lmdb_counter_t *counter = lmdb_counter_init("./test.lmdb", 8);
    assert(counter != NULL);

    buffer_t testbuf;
    buffer_init(&testbuf);

    clock_t time0 = clock();

    while (clock() < time0 + 10 * CLOCKS_PER_SEC) {
        printf("Yo!\n");
        lmdb_counter_inc(counter, "test");
        printf("weird %lu\n", lmdb_counter_get(counter, "test"));
        lmdb_counter_dump(counter, &testbuf);
        buffer_fast_clear(&testbuf);
    }

    clock_t time1 = clock();
    double duration = (time1 * 1.0 - time0) / CLOCKS_PER_SEC;
    uint64_t count = lmdb_counter_get(counter, "test");

    printf("after 10 seconds: %lu (%f per second)\n",
           count,
           count / duration);

    lmdb_counter_destroy(counter);

    return 0;
}
