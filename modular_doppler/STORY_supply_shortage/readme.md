## Title: Supply shortage

MODULE ID: SUPPLY_SHORTAGE

### Description:

TEMPORARY STORY MODULE. WILL BE REVERTED WHEN THE ARC ENDS.

### TG Proc Changes:

code/modules/cargo/orderconsole.dm - L192, added "shortagemult" = pack.get_shortage_price_mult(),
code/modules/modular_computers/file_system/programs/dept_order.dm - L88 - L99

tgui/packages/tgui/interfaces/NtosDeptOrder.tsx - L31-L32, L211-213, L223
tgui/packages/tgui/interfaces/Cargo/CargoCatalog.tsx - L201-L204, L221-L223, L241-L245
tgui/packages/tgui/interfaces/Cargo/types.ts - L42

config/config.txt - L6

### Defines:

N/A

### Master file additions

N/A

### Included files that are not contained in this module:

config/doppler/STORY_SUPPLY_SHORTAGE.txt

### Credits:

Niko
