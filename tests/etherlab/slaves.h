/* Master 0, Slave 0, "EL1004"
 * Vendor ID:       0x00000002
 * Product code:    0x03ec3052
 * Revision number: 0x00130000
 */

ec_pdo_entry_info_t slave_0_pdo_entries[] = {
    {0x6000, 0x01, 1}, /* Input */
    {0x6010, 0x01, 1}, /* Input */
    {0x6020, 0x01, 1}, /* Input */
    {0x6030, 0x01, 1}, /* Input */
};

ec_pdo_info_t slave_0_pdos[] = {
    {0x1a00, 1, slave_0_pdo_entries + 0}, /* Channel 1 */
    {0x1a01, 1, slave_0_pdo_entries + 1}, /* Channel 2 */
    {0x1a02, 1, slave_0_pdo_entries + 2}, /* Channel 3 */
    {0x1a03, 1, slave_0_pdo_entries + 3}, /* Channel 4 */
};

ec_sync_info_t slave_0_syncs[] = {
    {0, EC_DIR_INPUT, 4, slave_0_pdos + 0, EC_WD_DISABLE},
    {0xff}
};

/* Master 0, Slave 1, "EL1004"
 * Vendor ID:       0x00000002
 * Product code:    0x03ec3052
 * Revision number: 0x00130000
 */

ec_pdo_entry_info_t slave_1_pdo_entries[] = {
    {0x6000, 0x01, 1}, /* Input */
    {0x6010, 0x01, 1}, /* Input */
    {0x6020, 0x01, 1}, /* Input */
    {0x6030, 0x01, 1}, /* Input */
};

ec_pdo_info_t slave_1_pdos[] = {
    {0x1a00, 1, slave_1_pdo_entries + 0}, /* Channel 1 */
    {0x1a01, 1, slave_1_pdo_entries + 1}, /* Channel 2 */
    {0x1a02, 1, slave_1_pdo_entries + 2}, /* Channel 3 */
    {0x1a03, 1, slave_1_pdo_entries + 3}, /* Channel 4 */
};

ec_sync_info_t slave_1_syncs[] = {
    {0, EC_DIR_INPUT, 4, slave_1_pdos + 0, EC_WD_DISABLE},
    {0xff}
};

/* Master 0, Slave 2, "EL2004"
 * Vendor ID:       0x00000002
 * Product code:    0x07d43052
 * Revision number: 0x00120000
 */

ec_pdo_entry_info_t slave_2_pdo_entries[] = {
    {0x7000, 0x01, 1}, /* Output */
    {0x7010, 0x01, 1}, /* Output */
    {0x7020, 0x01, 1}, /* Output */
    {0x7030, 0x01, 1}, /* Output */
};

ec_pdo_info_t slave_2_pdos[] = {
    {0x1600, 1, slave_2_pdo_entries + 0}, /* Channel 1 */
    {0x1601, 1, slave_2_pdo_entries + 1}, /* Channel 2 */
    {0x1602, 1, slave_2_pdo_entries + 2}, /* Channel 3 */
    {0x1603, 1, slave_2_pdo_entries + 3}, /* Channel 4 */
};

ec_sync_info_t slave_2_syncs[] = {
    {0, EC_DIR_OUTPUT, 4, slave_2_pdos + 0, EC_WD_ENABLE},
    {0xff}
};

/* Master 0, Slave 3, "EL2004"
 * Vendor ID:       0x00000002
 * Product code:    0x07d43052
 * Revision number: 0x00120000
 */

ec_pdo_entry_info_t slave_3_pdo_entries[] = {
    {0x7000, 0x01, 1}, /* Output */
    {0x7010, 0x01, 1}, /* Output */
    {0x7020, 0x01, 1}, /* Output */
    {0x7030, 0x01, 1}, /* Output */
};

ec_pdo_info_t slave_3_pdos[] = {
    {0x1600, 1, slave_3_pdo_entries + 0}, /* Channel 1 */
    {0x1601, 1, slave_3_pdo_entries + 1}, /* Channel 2 */
    {0x1602, 1, slave_3_pdo_entries + 2}, /* Channel 3 */
    {0x1603, 1, slave_3_pdo_entries + 3}, /* Channel 4 */
};

ec_sync_info_t slave_3_syncs[] = {
    {0, EC_DIR_OUTPUT, 4, slave_2_pdos + 0, EC_WD_ENABLE},
    {1, EC_DIR_OUTPUT, 4, slave_3_pdos + 0, EC_WD_ENABLE},
    {0xff}
};

