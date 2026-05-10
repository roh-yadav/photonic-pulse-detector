#!/usr/bin/env python3
# ============================================
# Photonic Pulse Detector — Live Visualizer
# Author: Rohit Yadav 
# ============================================

import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib.widgets import Button, Slider
import random

# ---- Pulse Simulator ----
class PulseSimulator:
    def __init__(self):
        self.time_data      = []
        self.pulse_data     = []
        self.width_data     = []
        self.freq_data      = []
        self.rising_data    = []
        self.falling_data   = []
        self.t              = 0
        self.pulse_active   = False
        self.pulse_timer    = 0
        self.pulse_interval = random.randint(5, 15)
        self.running        = False  # start paused
        self.pulse_rate     = 10    # default pulse rate

    def update(self):
        if not self.running:
            # freeze everything when stopped
            return

        self.t += 1
        self.time_data.append(self.t)

        if not self.pulse_active:
            self.pulse_timer += 1
            if self.pulse_timer >= self.pulse_rate:
                self.pulse_active   = True
                self.pulse_timer    = 0
                self.pulse_width    = random.randint(3, 15)
                self.pulse_interval = random.randint(5, 20)
                self.rising_data.append(self.t)
        else:
            self.pulse_timer += 1
            if self.pulse_timer >= self.pulse_width:
                self.pulse_active = False
                self.pulse_timer  = 0
                self.falling_data.append(self.t)
                self.width_data.append(self.pulse_width)
                self.freq_data.append(len(self.rising_data))

        self.pulse_data.append(1 if self.pulse_active else 0)

        if len(self.time_data) > 100:
            self.time_data.pop(0)
            self.pulse_data.pop(0)

# ---- Setup figure ----
fig = plt.figure(figsize=(13, 9))
fig.patch.set_facecolor('#0d0d0d')
fig.suptitle('Photonic Pulse Detector IC — Live Monitor | SKY130 130nm',
             color='white', fontsize=12, fontweight='bold')

# plot areas
ax1 = fig.add_axes([0.08, 0.62, 0.88, 0.22])
ax2 = fig.add_axes([0.08, 0.35, 0.88, 0.22])
ax3 = fig.add_axes([0.08, 0.12, 0.88, 0.18])

# button and slider areas
ax_btn   = fig.add_axes([0.08, 0.02, 0.15, 0.06])
ax_reset = fig.add_axes([0.25, 0.02, 0.15, 0.06])
ax_slide = fig.add_axes([0.50, 0.02, 0.40, 0.04])

sim = PulseSimulator()

# style all plots
for ax in [ax1, ax2, ax3]:
    ax.set_facecolor('#0d0d0d')
    ax.tick_params(colors='white')
    for spine in ax.spines.values():
        spine.set_color('#333333')

ax1.set_title('Optical Pulse Signal', color='#1D9E75', fontsize=10)
ax1.set_ylabel('Signal', color='white')
ax1.set_ylim(-0.2, 1.5)

ax2.set_title('Pulse Width History (clock cycles)', color='#7F77DD', fontsize=10)
ax2.set_ylabel('Width (cycles)', color='white')

ax3.set_title('Cumulative Pulse Count', color='#D85A30', fontsize=10)
ax3.set_ylabel('Pulses', color='white')
ax3.set_xlabel('Time (cycles)', color='white')

line1, = ax1.plot([], [], color='#1D9E75', linewidth=1.5)
rising_scatter  = ax1.scatter([], [], color='#00ff88', s=60, zorder=5, label='Rising ↑')
falling_scatter = ax1.scatter([], [], color='#ff4444', s=60, zorder=5, label='Falling ↓')
ax1.legend(loc='upper right', facecolor='#1a1a1a', labelcolor='white', fontsize=8)

line3, = ax3.plot([], [], color='#D85A30', linewidth=1.5)

# stats text
stats_text = fig.text(0.08, 0.915,
    'Status: STOPPED | Pulses: 0 | DRC: CLEAN ✓ | LVS: CLEAN ✓ | Die: 0.09mm² | Cells: 311',
    color='#888888', fontsize=8, family='monospace')

# cycle counter display — top right
cycle_text = fig.text(0.75, 0.955,
    'CYCLE: 0',
    color='#1D9E75', fontsize=14, family='monospace', fontweight='bold')

# pulse width display
width_text = fig.text(0.75, 0.935,
    'WIDTH: -- cycles',
    color='#7F77DD', fontsize=10, family='monospace')

# pulse count display
count_text = fig.text(0.75, 0.918,
    'TOTAL PULSES: 0',
    color='#D85A30', fontsize=10, family='monospace')

# alert display
alert_text = fig.text(0.08, 0.955,
    '',
    color='#ff4444', fontsize=12, family='monospace', fontweight='bold')

# ---- Toggle Button ----
btn_toggle = Button(ax_btn, '▶ START', color='#1a3a1a', hovercolor='#2a5a2a')
btn_toggle.label.set_color('#1D9E75')
btn_toggle.label.set_fontweight('bold')

def toggle(event):
    sim.running = not sim.running
    if sim.running:
        btn_toggle.label.set_text('⏹ STOP')
        btn_toggle.ax.set_facecolor('#3a1a1a')
        btn_toggle.label.set_color('#ff4444')
    else:
        btn_toggle.label.set_text('▶ START')
        btn_toggle.ax.set_facecolor('#1a3a1a')
        btn_toggle.label.set_color('#1D9E75')
    fig.canvas.draw()

btn_toggle.on_clicked(toggle)

# ---- Reset Button ----
btn_reset = Button(ax_reset, '↺ RESET', color='#1a1a3a', hovercolor='#2a2a5a')
btn_reset.label.set_color('#7F77DD')
btn_reset.label.set_fontweight('bold')

def reset(event):
    sim.time_data.clear()
    sim.pulse_data.clear()
    sim.width_data.clear()
    sim.freq_data.clear()
    sim.rising_data.clear()
    sim.falling_data.clear()
    sim.t            = 0
    sim.pulse_active = False
    sim.pulse_timer  = 0

btn_reset.on_clicked(reset)

# ---- Speed Slider ----
slider = Slider(ax_slide, 'Pulse Rate', 2, 30,
                valinit=10, color='#7F77DD')
slider.label.set_color('white')
slider.valtext.set_color('white')
ax_slide.set_facecolor('#1a1a1a')

def update_rate(val):
    sim.pulse_rate = int(slider.val)

slider.on_changed(update_rate)

# ---- Animation ----
def animate(frame):
    for _ in range(2):
        sim.update()

    # plot 1 — pulse signal
    line1.set_data(sim.time_data, sim.pulse_data)
    ax1.set_xlim(max(0, sim.t - 100), sim.t + 5)

    if sim.rising_data:
        recent_r = [t for t in sim.rising_data if t > sim.t - 100]
        if recent_r:
            rising_scatter.set_offsets([[t, 1.2] for t in recent_r])
    if sim.falling_data:
        recent_f = [t for t in sim.falling_data if t > sim.t - 100]
        if recent_f:
            falling_scatter.set_offsets([[t, 1.2] for t in recent_f])

    # plot 2 — pulse widths
    ax2.cla()
    ax2.set_facecolor('#0d0d0d')
    ax2.set_title('Pulse Width History (clock cycles)', color='#7F77DD', fontsize=10)
    ax2.set_ylabel('Width (cycles)', color='white')
    ax2.tick_params(colors='white')
    for spine in ax2.spines.values():
        spine.set_color('#333333')
    if sim.width_data:
        recent_w = sim.width_data[-20:]
        colors = ['#ff6666' if w > 12 else '#7F77DD' for w in recent_w]
        ax2.bar(range(len(recent_w)), recent_w, color=colors, alpha=0.8)
        ax2.set_xlim(-0.5, 20)
        ax2.set_ylim(0, 20)
        ax2.axhline(y=12, color='#ff4444', linestyle='--',
                    linewidth=0.8, alpha=0.5, label='Alert threshold')
        ax2.legend(facecolor='#1a1a1a', labelcolor='white', fontsize=8)

    # plot 3 — cumulative count
    if sim.freq_data:
        ax3.set_xlim(0, len(sim.freq_data) + 1)
        ax3.set_ylim(0, max(sim.freq_data) + 2)
        line3.set_data(range(len(sim.freq_data)), sim.freq_data)

    # update stats
    status     = "RUNNING ▶" if sim.running else "STOPPED ⏹"
    last_width = sim.width_data[-1] if sim.width_data else '--'
    total      = len(sim.rising_data)
  # update stats bar
    stats_text.set_text(
        f'Status: {status} | DRC: CLEAN ✓ | LVS: CLEAN ✓ | '
        f'Die: 0.09mm² | Cells: 311 | Power: 0.58µW'
    )

    # update live counters
    cycle_text.set_text(f'CYCLE: {sim.t}')
    width_text.set_text(f'WIDTH: {last_width} cycles')
    count_text.set_text(f'TOTAL PULSES: {total}')

    # alert if last pulse too wide
    if sim.width_data and sim.width_data[-1] > 12:
        alert_text.set_text('⚠ ALERT: PULSE TOO WIDE!')
    else:
        alert_text.set_text('')

    return line1, rising_scatter, falling_scatter, line3, stats_text, cycle_text, width_text, count_text, alert_text

    return line1, rising_scatter, falling_scatter, line3, stats_text

ani = animation.FuncAnimation(fig, animate, interval=100,
                               blit=False, cache_frame_data=False)
plt.show()
