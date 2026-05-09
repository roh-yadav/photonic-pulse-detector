#!/usr/bin/env python3
# ============================================
# OpenLane CSV output
# Author: Rohit Yadav 
# ============================================

import csv

def parse_metrics(csv_file):
    with open(csv_file, 'r') as f:
        reader = csv.DictReader(f)
        for row in reader:
            print("\n" + "="*50)
            print("  CHIP METRICS REPORT")
            print("="*50)

            print("\n--- FLOW STATUS ---")
            print(f"  Design Name    : {row['design_name']}")
            print(f"  Flow Status    : {row['flow_status']}")
            print(f"  Total Runtime  : {row['total_runtime']}")
            print(f"  Route Runtime  : {row['routed_runtime']}")

            print("\n--- CHIP SIZE ---")
            print(f"  Die Area       : {row['DIEAREA_mm^2']} mm²")
            print(f"  Core Area      : {float(row['CoreArea_um^2']):.2f} µm²")
            print(f"  Core Util      : {row['FP_CORE_UTIL']}%")

            print("\n--- CELL COUNT ---")
            print(f"  Logic Cells    : {row['synth_cell_count']}")
            print(f"  Total Cells    : {row['TotalCells']}")
            print(f"  DFF (registers): {row['DFF']}")
            print(f"  OR gates       : {row['OR']}")
            print(f"  AND gates      : {row['AND']}")
            print(f"  MUX cells      : {row['MUX']}")

            print("\n--- TIMING ---")
            print(f"  Critical Path  : {row['critical_path_ns']} ns")
            print(f"  Clock Period   : {row['CLOCK_PERIOD']} ns")
            slack = float(row['CLOCK_PERIOD']) - float(row['critical_path_ns'])
            print(f"  Timing Slack   : {slack:.2f} ns")
            print(f"  Clock Freq     : {row['suggested_clock_frequency']} MHz")
            print(f"  WNS            : {row['wns']} (0 = no violations)")
            print(f"  TNS            : {row['tns']} (0 = no violations)")

            print("\n--- POWER ---")
            p_int = float(row['power_typical_internal_uW'])
            p_sw  = float(row['power_typical_switching_uW'])
            p_lk  = float(row['power_typical_leakage_uW'])
            p_tot = p_int + p_sw + p_lk
            print(f"  Internal Power : {p_int:.6f} µW")
            print(f"  Switching Power: {p_sw:.6f} µW")
            print(f"  Leakage Power  : {p_lk:.9f} µW")
            print(f"  Total Power    : {p_tot:.6f} µW")

            print("\n--- ROUTING ---")
            print(f"  Wire Length    : {row['wire_length']} µm")
            print(f"  Total Vias     : {row['vias']}")
            print(f"  Met2 Usage     : {row['routing_layer2_pct']}%")
            print(f"  Met3 Usage     : {row['routing_layer3_pct']}%")

            print("\n--- VIOLATIONS ---")
            print(f"  DRC            : {row['Magic_violations']} ✓" if row['Magic_violations']=='0' else f"  DRC            : {row['Magic_violations']} VIOLATIONS!")
            print(f"  LVS Errors     : {row['lvs_total_errors']} ✓" if row['lvs_total_errors']=='0' else f"  LVS            : {row['lvs_total_errors']} ERRORS!")
            print(f"  Route Viol     : {row['tritonRoute_violations']} ✓" if row['tritonRoute_violations']=='0' else f"  Route          : {row['tritonRoute_violations']} VIOLATIONS!")
            print(f"  Antenna Pins   : {row['pin_antenna_violations']}")
            print(f"  Antenna Nets   : {row['net_antenna_violations']}")

            print("\n" + "="*50)

# run the parser
parse_metrics('metrics.csv')
