/**
 * Copyright (C) 2019 Beckhoff Automation GmbH & Co. KG
 *
 * Author: Patrick Brünn <p.bruenn@beckhoff.com>
 */

#include <csignal>
#include <sys/time.h>
#include <unistd.h>
#include <iostream>

#include "ecrt.h"

#define FREQUENCY 50

// EtherCAT
static ec_master_t *master = NULL;
static ec_master_state_t master_state = {};

static ec_domain_t *domain1 = NULL;
static ec_domain_state_t domain1_state = {};

// Timer
static unsigned int sig_alarms = 0;
static unsigned int user_alarms = 0;

// process data
static uint8_t *output_pd[2];

#define Beckhoff_EL1004 0x6000, 0x00000002, 0x03ec3052
#define Beckhoff_EL2004 0x7000, 0x00000002, 0x07d43052

#include "slaves.h"

static int Init_Slave(uint8_t** off, const uint16_t position, const uint16_t index, const uint32_t vendor_id, const uint32_t product_code, const ec_sync_info_t syncs[])
{
    ec_slave_config_t *sc;
    if (!(sc = ecrt_master_slave_config(master, 0, position, vendor_id, product_code))) {
        std::cerr << "Failed to get slave configuration.\n";
        return -1;
    }
    if (ecrt_slave_config_pdos(sc, EC_END, syncs)) {
        std::cerr << "Failed to configure PDOs.\n";
        return -1;
    }
    if (0 > (*off = ((uint8_t*)0) + (ecrt_slave_config_reg_pdo_entry(sc, index, 1, domain1, NULL)))) {
        std::cerr << "Failed to configure reg PDOs.\n";
        return -1;
    }
    return 0;
}

static void cyclic_task()
{
    static uint8_t val_output = 0;

    // receive process data
    ecrt_master_receive(master);
    ecrt_domain_process(domain1);

    // check process data state (optional)
    ecrt_domain_state(domain1, &domain1_state);

    // check for master state (optional)
    ecrt_master_state(master, &master_state);

    // write process data
    ++val_output;
    for (size_t i = 0; i < sizeof(output_pd)/sizeof(output_pd[0]); ++i) {
        static const auto CHANNELS_PER_OUTPUT = 4;
        static const auto CHANNEL_MASK = 0xF;
        const auto val = (val_output >> (i * CHANNELS_PER_OUTPUT)) & CHANNEL_MASK;
        EC_WRITE_U8(output_pd[i], val);
    }

    // send process data
    ecrt_domain_queue(domain1);
    ecrt_master_send(master);
}

static void signal_handler(int signum) {
    switch (signum) {
        case SIGALRM:
            sig_alarms++;
            break;
    }
}

static int run_demo(void)
{
    struct sigaction sa;
    struct itimerval tv;

    master = ecrt_request_master(0);
    if (!master)
        return -1;

    domain1 = ecrt_master_create_domain(master);
    if (!domain1)
        return -1;

    Init_Slave(output_pd + 0, 2, Beckhoff_EL2004, slave_2_syncs);
    Init_Slave(output_pd + 1, 3, Beckhoff_EL2004, slave_3_syncs);

    std::cout << "Activating master...\n";
    if (ecrt_master_activate(master)) {
        printf("Failed!\n");
        return -1;
    }

    const auto domain1_pd = ecrt_domain_data(domain1) - (uint8_t*)nullptr;
    if (!domain1_pd) {
        printf("Init domain1 failed with: 0x%x\n", domain1_pd);
        return -1;
    }

    output_pd[0] += domain1_pd;
    output_pd[1] += domain1_pd;

    sa.sa_handler = signal_handler;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if (sigaction(SIGALRM, &sa, 0)) {
        fprintf(stderr, "Failed to install signal handler!\n");
        return -1;
    }

    std::cout << "Starting timer...\n";
    tv.it_interval.tv_sec = 0;
    tv.it_interval.tv_usec = 1000000 / FREQUENCY;
    tv.it_value.tv_sec = 0;
    tv.it_value.tv_usec = 1000;
    if (setitimer(ITIMER_REAL, &tv, NULL)) {
        std::cerr << "Failed to start timer: errno: " << std::dec << errno <<'\n';
        return 1;
    }

    while (1) {
        pause();

        while (sig_alarms != user_alarms) {
            cyclic_task();
            user_alarms++;
        }
    }

    return 0;
}


int main(int argc, char **argv)
{
	return run_demo();
}
