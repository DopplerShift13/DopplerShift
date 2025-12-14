
/**
 * Defines used by the charging stomach and its subtypes.
 * Try to keep as many of these relative to the max charge defines, where fitting.
 */

/// The default maximum energy for a charging stomach.
#define CHARGING_STOMACH_CHARGE_FULL (5 MEGA JOULES)
/// The default energy level at which a charging stomach starts.
#define CHARGING_STOMACH_CHARGE_START CHARGING_STOMACH_CHARGE_FULL
/// The default energy level below which a charging stomach considers itself low on charge.
#define CHARGING_STOMACH_CHARGE_LOW (CHARGING_STOMACH_CHARGE_FULL * 3 / 10)
/// The default amount of energy we charge back up to on revival.
#define CHARGING_STOMACH_REVIVAL_CHARGE (CHARGING_STOMACH_CHARGE_FULL / 10)
/// The default amount by which a charging stomach discharges every second.
#define CHARGING_STOMACH_DISCHARGE_RATE (CHARGING_STOMACH_CHARGE_FULL / 2000)
/// The default amount by which a charging stomach discharges when EMP'd.
#define CHARGING_STOMACH_EMP_DISCHARGE (CHARGING_STOMACH_DISCHARGE_RATE * 30)
